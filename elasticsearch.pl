#!/usr/bin/perl

use strict;
use warnings;

use LWP::UserAgent;
use JSON::XS;
use Storable;

my $self = {
    port => 9200,
    http => 'http'
};

# Cluster health
$self->{cluster_health} = {
    url    => '/_cluster/health',
    fields => {
        active_primary_shards     => 'active_primary_shards',
        active_shards             => 'active_shards',
        relocating_shards         => 'relocating_shards',
        initializing_shards       => 'initializing_shards',
        unassigned_shards         => 'unassigned_shards',
        delayed_unassigned_shards => 'delayed_unassigned_shards',
        cluster_red               => 'cluster_red',
        cluster_yellow            => 'cluster_yellow',
        cluster_green             => 'cluster_green',
    }
};

# Cluster pending tasks
$self->{cluster_pendingtasks} = {
    url    => '/_cluster/pending_tasks',
    fields => {
        immediate => 'immediate',
        urgent    => 'urgent',
        high      => 'high',
        normal    => 'normal',
        low       => 'low',
        languid   => 'languid'
    }
};

# Shards
$self->{shards} = {
    url    => '/_cat/shards/?h=node,prirep,state',
    fields => {
        shard        => 'shards',
        primary      => 'primary',
        replica      => 'replica',
        other        => 'other',
        started      => 'started',
        unassigned   => 'unassigned',
        initializing => 'initializing',
        otherstate   => 'other_state'
    }
};

# Nodes
$self->{nodes} = {
    url    => '/_nodes/<param>/stats',
    fields => {
        breaker_request_limit_size_in_bytes                => 'request_limit_size',
        breaker_request_limit_size                         => undef,
        breaker_request_estimated_size_in_bytes            => 'request_estimated_size',
        breaker_request_estimated_size                     => undef,
        breaker_request_overhead                           => undef,
        breaker_request_tripped                            => 'request_tripped',
        breaker_fielddata_limit_size_in_bytes              => 'fielddata_limit_size',
        breaker_fielddata_limit_size                       => undef,
        breaker_fielddata_estimated_size_in_bytes          => 'fielddata_estimated_size',
        breaker_fielddata_estimated_size                   => undef,
        breaker_fielddata_overhead                         => undef,
        breaker_fielddata_tripped                          => 'fielddata_tripped',
        breaker_in_flight_requests_limit_size_in_bytes     => undef,
        breaker_in_flight_requests_limit_size              => undef,
        breaker_in_flight_requests_estimated_size_in_bytes => undef,
        breaker_in_flight_requests_estimated_size          => undef,
        breaker_in_flight_requests_overhead                => undef,
        breaker_in_flight_requests_tripped                 => undef,
        breaker_parent_limit_size_in_bytes                 => 'parent_limit_size',
        breaker_parent_limit_size                          => undef,
        breaker_parent_estimated_size_in_bytes             => 'parent_estimated_size',
        breaker_parent_estimated_size                      => undef,
        breaker_parent_overhead                            => undef,
        breaker_parent_tripped                             => 'parent_tripped',
        fs_total_total_in_bytes                            => 'total_in_bytes',
        fs_total_free_in_bytes                             => 'free_in_bytes',
        fs_total_available_in_bytes                        => 'available_in_bytes',
        fs_total_spins                                     => undef,
        fs_io_stats_total_operations                       => 'disk_io_op',
        fs_io_stats_total_read_operations                  => 'disk_reads',
        fs_io_stats_total_write_operations                 => 'disk_writes',
        fs_io_stats_total_read_kilobytes                   => 'disk_read_size_in_bytes',
        fs_io_stats_total_write_kilobytes                  => 'disk_write_size_in_bytes',
        http_current_open                                  => 'http_open',
        http_total_opened                                  => 'http_total',
        indices_docs_count                                 => 'docs_count',
        indices_docs_deleted                               => 'docs_deleted',
        indices_store_size_in_bytes                        => 'indices_store',
        indices_store_throttle_time_in_millis              => undef,
        indices_indexing_index_total                       => 'index_total',
        indices_indexing_index_time_in_millis              => 'index_millis',
        indices_indexing_index_current                     => 'index_current',
        indices_indexing_index_failed                      => 'index_failed',
        indices_indexing_delete_total                      => 'index_delete_total',
        indices_indexing_delete_time_in_millis             => 'index_delete_millis',
        indices_indexing_delete_current                    => 'index_delete',
        indices_indexing_noop_update_total                 => undef,
        indices_indexing_is_throttled                      => undef,
        indices_indexing_throttle_time_in_millis           => undef,
        indices_get_total                                  => 'get_total',
        indices_get_time_in_millis                         => 'get_time_in_millis',
        indices_get_exists_total                           => 'get_exists_total',
        indices_get_exists_time_in_millis                  => 'get_exists_time_in_millis',
        indices_get_missing_total                          => 'get_missing_total',
        indices_get_missing_time_in_millis                 => 'get_missing_time_in_millis',
        indices_get_current                                => 'get',
        indices_search_open_contexts                       => undef,
        indices_search_query_total                         => 'search_total',
        indices_search_query_time_in_millis                => 'search_query_time_in_millis',
        indices_search_query_current                       => 'search_query',
        indices_search_fetch_total                         => 'search_fetch_total',
        indices_search_fetch_time_in_millis                => 'search_fetch_time_in_millis',
        indices_search_fetch_current                       => 'search_fetch',
        indices_search_scroll_total                        => 'search_scroll_total',
        indices_search_scroll_time_in_millis               => 'search_scroll_time_in_millis',
        indices_search_scroll_current                      => 'search_scroll',
        indices_search_suggest_total                       => 'search_suggest_total',
        indices_search_suggest_time_in_millis              => 'search_suggest_time_in_millis',
        indices_search_suggest_current                     => 'search_suggest',
        indices_merges_current                             => 'merges',
        indices_merges_current_docs                        => 'merges_current_docs',
        indices_merges_current_size_in_bytes               => 'merges_current_size',
        indices_merges_total                               => 'merges_total',
        indices_merges_total_time_in_millis                => 'merges_total_time_in_millis',
        indices_merges_total_docs                          => 'merges_total_docs',
        indices_merges_total_size_in_bytes                 => 'merges_total_size',
        indices_merges_total_stopped_time_in_millis        => undef,
        indices_merges_total_throttled_time_in_millis      => undef,
        indices_merges_total_auto_throttle_in_bytes        => undef,
        indices_refresh_total                              => 'refresh_total',
        indices_refresh_total_time_in_millis               => 'refresh_total_time_in_millis',
        indices_refresh_listeners                          => undef,
        indices_flush_total                                => 'flush_total',
        indices_flush_total_time_in_millis                 => 'flush_total_time_in_millis',
        indices_warmer_current                             => 'warmer',
        indices_warmer_total                               => 'warmer_total',
        indices_warmer_total_time_in_millis                => 'warmer_total_time_in_millis',
        indices_query_cache_memory_size_in_bytes           => 'query_cache',
        indices_query_cache_total_count                    => 'query_cache_total',
        indices_query_cache_hit_count                      => 'query_cache_hit_count',
        indices_query_cache_miss_count                     => 'query_cache_miss_count',
        indices_query_cache_cache_size                     => undef,
        indices_query_cache_cache_count                    => undef,
        indices_query_cache_evictions                      => 'query_cache_evictions',
        indices_fielddata_memory_size_in_bytes             => 'field_data',
        indices_fielddata_evictions                        => 'fielddata_evictions',
        indices_eompletion_size_in_bytes                   => 'completion_size',
        indices_segments_count                             => 'segments_count',
        indices_segments_memory_in_bytes                   => 'segments_memory',
        indices_segments_terms_memory_in_bytes             => undef,
        indices_segments_stored_fields_memory_in_bytes     => undef,
        indices_segments_term_vectors_memory_in_bytes      => undef,
        indices_segments_norms_memory_in_bytes             => undef,
        indices_segments_points_memory_in_bytes            => undef,
        indices_segments_doc_values_memory_in_bytes        => undef,
        indices_segments_index_writer_memory_in_bytes      => 'segments_index_writer_memory',
        indices_segments_version_map_memory_in_bytes       => 'segments_version_map_memory',
        indices_segments_fixed_bit_set_memory_in_bytes     => 'segments_fixed_bit_set_memory',
        indices_segments_max_unsafe_auto_id_timestamp      => undef,
        indices_translog_operations                        => 'translog_ops',
        indices_translog_size_in_bytes                     => 'translog_size',
        indices_request_cache_memory_size_in_bytes         => 'request_cache',
        indices_request_cache_evictions                    => 'request_cache_evictions',
        indices_request_cache_hit_count                    => 'request_cache_hit_count',
        indices_request_cache_miss_count                   => 'request_cache_miss_count',
        indices_recovery_current_as_source                 => 'recovery_current_source',
        indices_recovery_current_as_target                 => 'recovery_current_target',
        indices_recovery_throttle_time_in_millis           => undef,
        jvm_mem_heap_used_in_bytes                         => 'heap_used_in_bytes',
        jvm_mem_heap_used_percent                          => 'heap_used_percent',
        jvm_mem_heap_committed_in_bytes                    => 'heap_committed_in_bytes',
        jvm_mem_heap_max_in_bytes                          => 'heap_max_in_bytes',
        jvm_mem_non_heap_used_in_bytes                     => 'non_heap_used_in_bytes',
        jvm_mem_non_heap_committed_in_bytes                => 'non_heap_committed_in_bytes',
        jvm_mem_pools_young_used_in_bytes                  => 'young_used_in_bytes',
        jvm_mem_pools_young_max_in_bytes                   => 'young_max_in_bytes',
        jvm_mem_pools_young_peak_used_in_bytes             => 'young_peak_used_in_bytes',
        jvm_mem_pools_young_peak_max_in_bytes              => 'young_peak_max_in_bytes',
        jvm_mem_pools_survivor_used_in_bytes               => 'survivor_used_in_bytes',
        jvm_mem_pools_survivor_max_in_bytes                => 'survivor_max_in_bytes',
        jvm_mem_pools_survivor_peak_used_in_bytes          => 'survivor_peak_used_in_bytes',
        jvm_mem_pools_survivor_peak_max_in_bytes           => 'survivor_peak_max_in_bytes',
        jvm_mem_pools_old_used_in_bytes                    => 'old_used_in_bytes',
        jvm_mem_pools_old_max_in_bytes                     => 'old_max_in_bytes',
        jvm_mem_pools_old_peak_used_in_bytes               => 'old_peak_used_in_bytes',
        jvm_mem_pools_old_peak_max_in_bytes                => 'old_peak_max_in_bytes',
        jvm_threads_count                                  => 'threads',
        jvm_peak_count                                     => 'threads_peak',
        jvm_gc_collectors_young_collection_count           => 'young_collection_count',
        jvm_gc_collectors_young_collection_time_in_millis  => 'young_collection_time',
        jvm_gc_collectors_old_collection_count             => 'old_collection_count',
        jvm_gc_collectors_old_collection_time_in_millis    => 'old_collection_time',
        jvm_buffer_pools_direct_count                      => 'direct_count',
        jvm_buffer_pools_direct_count_used_in_bytes        => 'direct_used_in_bytes',
        jvm_buffer_pools_direct_total_capacity_in_bytes    => 'direct_total_capacity_in_bytes',
        jvm_buffer_pools_mapped_count                      => 'mapped_count',
        jvm_buffer_pools_mapped_used_in_bytes              => 'mapped_used_in_bytes',
        jvm_buffer_pools_mapped_total_capacity_in_bytes    => 'mapped_total_capacity_in_bytes',
        jvm_classes_current_loaded_count                   => 'classes_current_loaded_count',
        jvm_classes_total_loaded_count                     => 'classes_total_loaded_count',
        jvm_classes_total_unloaded_count                   => 'classes_total_unloaded_count',
        os_cpu_percent                                     => undef,
        os_cpu_load_average_1m                             => 'load_average_1',
        os_cpu_load_average_5m                             => 'load_average_5',
        os_cpu_load_average_15m                            => 'load_average_15',
        os_mem_total_in_bytes                              => undef,
        os_mem_free_in_bytes                               => 'mem_free_in_bytes',
        os_mem_used_in_bytes                               => 'mem_used_in_bytes',
        os_mem_free_percent                                => 'mem_free_percent',
        os_mem_used_percent                                => 'mem_used_percent',
        os_swap_total_in_bytes                             => undef,
        os_swap_free_in_bytes                              => 'swap_free_in_bytes',
        os_swap_used_in_bytes                              => 'swap_used_in_bytes',
        os_cgroup_cpuacct_control_group                    => undef,
        os_cgroup_cpuacct_usage_nanos                      => undef,
        os_cgroup_cpu_control_group                        => undef,
        os_cgroup_cpu_cfs_period_micros                    => undef,
        os_cgroup_cpu_cfs_quota_micros                     => undef,
        os_cgroup_cpu_stats_number_of_elapsed_periods      => undef,
        os_cgroup_cpu_stats_number_of_times_throttled      => undef,
        os_cgroup_cpu_stats_time_throttled_nanos           => undef,
        process_open_file_descriptors                      => 'process_open_file_descriptors',
        process_max_file_descriptors                       => undef,
        process_cpu_percent                                => 'process_cpu_percent',
        process_cpu_total_in_millis                        => 'process_cpu_total_in_millis',
        process_mem_total_virtual_in_bytes                 => 'process_mem_total_virtual_in_bytes',
        thread_pool_bulk_threads                           => 'bulk_threads',
        thread_pool_bulk_queue                             => 'bulk_queue',
        thread_pool_bulk_active                            => 'bulk_active',
        thread_pool_bulk_rejected                          => 'bulk_rejected',
        thread_pool_bulk_largest                           => undef,
        thread_pool_bulk_completed                         => 'bulk_completed',
        thread_pool_fetch_shard_started_threads            => 'fetch_shard_started_threads',
        thread_pool_fetch_shard_started_queue              => 'fetch_shard_started_queue',
        thread_pool_fetch_shard_started_active             => 'fetch_shard_started_active',
        thread_pool_fetch_shard_started_rejected           => 'fetch_shard_started_rejected',
        thread_pool_fetch_shard_started_largest            => undef,
        thread_pool_fetch_shard_started_completed          => 'fetch_shard_started_completed',
        thread_pool_fetch_shard_store_threads              => 'fetch_shard_store_threads',
        thread_pool_fetch_shard_store_queue                => 'fetch_shard_store_queue',
        thread_pool_fetch_shard_store_active               => 'fetch_shard_store_active',
        thread_pool_fetch_shard_store_rejected             => 'fetch_shard_store_rejected',
        thread_pool_fetch_shard_store_largest              => undef,
        thread_pool_fetch_shard_store_completed            => 'fetch_shard_store_completed',
        thread_pool_flush_threads                          => 'flush_threads',
        thread_pool_flush_queue                            => 'flush_queue',
        thread_pool_flush_active                           => 'flush_active',
        thread_pool_flush_rejected                         => 'flush_rejected',
        thread_pool_flush_largest                          => undef,
        thread_pool_flush_completed                        => 'flush_completed',
        thread_pool_force_merge_threads                    => 'merge_threads',
        thread_pool_force_merge_queue                      => 'merge_queue',
        thread_pool_force_merge_active                     => 'merge_active',
        thread_pool_force_merge_rejected                   => 'merge_rejected',
        thread_pool_force_merge_largest                    => undef,
        thread_pool_force_merge_completed                  => 'merge_completed',
        thread_pool_generic_threads                        => 'generic_threads',
        thread_pool_generic_queue                          => 'generic_queue',
        thread_pool_generic_active                         => 'generic_active',
        thread_pool_generic_rejected                       => 'generic_rejected',
        thread_pool_generic_largest                        => undef,
        thread_pool_generic_completed                      => 'generic_completed',
        thread_pool_get_threads                            => 'get_threads',
        thread_pool_get_queue                              => 'get_queue',
        thread_pool_get_active                             => 'get_active',
        thread_pool_get_rejected                           => 'get_rejected',
        thread_pool_get_largest                            => undef,
        thread_pool_get_completed                          => 'get_completed',
        thread_pool_index_threads                          => 'index_threads',
        thread_pool_index_queue                            => 'index_queue',
        thread_pool_index_active                           => 'index_active',
        thread_pool_index_rejected                         => 'index_rejected',
        thread_pool_index_largest                          => undef,
        thread_pool_index_completed                        => 'index_completed',
        thread_pool_listener_threads                       => 'listener_threads',
        thread_pool_listener_queue                         => 'listener_queue',
        thread_pool_listener_active                        => 'listener_active',
        thread_pool_listener_rejected                      => 'listener_rejected',
        thread_pool_listener_largest                       => undef,
        thread_pool_listener_completed                     => 'listener_completed',
        thread_pool_management_threads                     => 'management_threads',
        thread_pool_management_queue                       => 'management_queue',
        thread_pool_management_active                      => 'management_active',
        thread_pool_management_rejected                    => 'management_rejected',
        thread_pool_management_largest                     => undef,
        thread_pool_management_completed                   => 'management_completed',
        thread_pool_refresh_threads                        => 'refresh_threads',
        thread_pool_refresh_queue                          => 'refresh_queue',
        thread_pool_refresh_active                         => 'refresh_active',
        thread_pool_refresh_rejected                       => 'refresh_rejected',
        thread_pool_refresh_largest                        => undef,
        thread_pool_refresh_completed                      => 'refresh_completed',
        thread_pool_search_threads                         => 'search_threads',
        thread_pool_search_queue                           => 'search_queue',
        thread_pool_search_active                          => 'search_active',
        thread_pool_search_rejected                        => 'search_rejected',
        thread_pool_search_largest                         => undef,
        thread_pool_search_completed                       => 'search_completed',
        thread_pool_snapshot_threads                       => 'snapshot_threads',
        thread_pool_snapshot_queue                         => 'snapshot_queue',
        thread_pool_snapshot_active                        => 'snapshot_active',
        thread_pool_snapshot_rejected                      => 'snapshot_rejected',
        thread_pool_snapshot_largest                       => undef,
        thread_pool_snapshot_completed                     => 'snapshot_completed',
        thread_pool_warmer_threads                         => 'warmer_threads',
        thread_pool_warmer_queue                           => 'warmer_queue',
        thread_pool_warmer_active                          => 'warmer_active',
        thread_pool_warmer_rejected                        => 'warmer_rejected',
        thread_pool_warmer_largest                         => undef,
        thread_pool_warmer_completed                       => 'warmer_completed',
        transport_server_open                              => 'server_open',
        transport_rx_count                                 => 'rx_count',
        transport_rx_size_in_bytes                         => 'rx_size_in_bytes',
        transport_tx_count                                 => 'tx_count',
        transport_tx_size_in_bytes                         => 'tx_size_in_bytes'
    }
};


if ( $ARGV[0] && $ARGV[1] ) {
    $self->{host}   = $ARGV[0];
    $self->{method} = $ARGV[1];
    $self->{param}  = $ARGV[2];
}
else {
    print STDERR "Missing params host or method\n";
    exit;
}


if ( $self->{method} ) {

    if ( $self->{method} eq "cluster" ) {
        my @returns;

        # Cluster health
        my $health = request( $self, 'cluster_health' );
        if ( $health->{status} ) {
            if ( $health->{status} =~ /green/ ) {
                $health->{cluster_green} = 1;
            }
            elsif ( $health->{status} =~ /yellow/ ) {
                $health->{cluster_yellow} = 1;
            }
            elsif ( $health->{status} =~ /red/ ) {
                $health->{cluster_red} = 1;
            }
        }
        push @returns, response( $self, 'cluster_health', $health );

        # Cluster pending tasks
        my $pending = request( $self, 'cluster_pendingtasks' );
        foreach my $p ( @{ $pending->{tasks} } ) {
            $pending->{ lc( $p->{priority} ) }++;
        }
        push @returns, response( $self, 'cluster_pendingtasks', $pending );

        answer(@returns);
    }
    elsif ( $self->{method} eq "shards" ) {

        if ( $self->{param} ) {

            # Shards
            my $shards = request( $self, 'shards' );
            my $data;

            foreach my $s (@$shards) {
                next if ( !$s->{node} || $s->{node} ne $self->{param} );

                # Count shards
                $data->{shard}++;

                # Count primary/replica
                if ( $s->{prirep} ) {
                    if ( $s->{prirep} eq 'p' ) {
                        $data->{primary}++;
                    }
                    elsif ( $s->{prirep} eq 'r' ) {
                        $data->{replica}++;
                    }
                    else {
                        $data->{other}++;
                    }
                }

                # Count states
                if ( $s->{state} ) {
                    if ( $s->{state} eq "STARTED" ) {
                        $data->{started}++;
                    }
                    elsif ( $s->{state} eq "UNASSIGNED" ) {
                        $data->{unassigned}++;
                    }
                    elsif ( $s->{state} eq "INITIALIZING" ) {
                        $data->{initializing}++;
                    }
                    else {
                        $data->{otherstate}++;
                    }
                }
            }
            answer( response( $self, 'shards', $data ) );

        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "jvm" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get JVM splat stats
            my $stats = splat( 'jvm', $nodes->{nodes}{$id}{jvm} );
            answer( response( $self, 'nodes', $stats, 'jvm' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "transport" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get Transport splat stats
            my $stats = splat( 'transport', $nodes->{nodes}{$id}{transport} );
            answer( response( $self, 'nodes', $stats, 'transport' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "http" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get http splat stats
            my $stats = splat( 'http', $nodes->{nodes}{$id}{http} );
            answer( response( $self, 'nodes', $stats, 'http' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "breaker" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get breaker splat stats
            my $stats = splat( 'breaker', $nodes->{nodes}{$id}{breakers} );
            answer( response( $self, 'nodes', $stats, 'breaker' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "os" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get os splat stats
            my $stats = splat( 'os', $nodes->{nodes}{$id}{os} );
            answer( response( $self, 'nodes', $stats, 'os' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "process" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get process splat stats
            my $stats = splat( 'process', $nodes->{nodes}{$id}{process} );
            answer( response( $self, 'nodes', $stats, 'process' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "fs" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get FS splat stats
            my $stats = splat( 'fs', $nodes->{nodes}{$id}{fs} );
            answer( response( $self, 'nodes', $stats, 'fs' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "thread_pool" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get Tread Pool splat stats
            my $stats = splat( 'thread_pool', $nodes->{nodes}{$id}{thread_pool} );
            answer( response( $self, 'nodes', $stats, 'thread_pool' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    elsif ( $self->{method} eq "indices" ) {

        if ( $self->{param} ) {

            # Nodes
            my $nodes = request( $self, 'nodes' );

            # Get NodeId
            my $id = ( keys %{ $nodes->{nodes} } )[0];

            # Get Indices splat stats
            my $stats = splat( 'indices', $nodes->{nodes}{$id}{indices} );
            answer( response( $self, 'nodes', $stats, 'indices' ) );
        }
        else {
            print STDERR "Missing params node name\n";
        }
    }
    else {
        print STDERR "Error method " . $self->{method} . " is unknown\n";
    }
}
else {
    print STDERR "Error method is required\n";
}

sub splat {

    my $path = shift;
    my $hash = shift;
    my $return;

    while ( my ( $key, $value ) = each %{$hash} ) {
        if ( ref $value eq 'HASH' ) {
            my $splat = splat( $path . '_' . $key, $value );
            if ($splat) {
                while ( my ( $k, $v ) = each %{$splat} ) {
                    $return->{$k} = $v;
                }
            }
        }
        else {
            $return->{ $path . "_" . $key } = $value;
        }
    }
    return $return;
}

sub answer {

    my @returns = @_;
    print join( ' ', @returns );

}

sub response {

    my ( $self, $api, $data, $filter ) = @_;
    my @returns;

    foreach my $key ( keys %{ $self->{$api}{fields} } ) {
        next if ( not $self->{$api}{fields}{$key} );
        next if ( $filter && $key !~ /^$filter/ );
        my $value = $data->{$key} || 0;
        push @returns, $self->{$api}{fields}{$key} . ":" . $value;
    }
    return @returns;
}

sub request {

    my ( $self, $api ) = @_;

    if ($api) {

        my $data;
        my $elapsed = 1000;
        my $file    = '/tmp/' . $self->{host} . '_' . $self->{method} . '_elasticsearch.data';
        $data = retrieve($file) if ( -e $file );
        if ( $data && $data->{timestamp} ) {
            $elapsed = time() - $data->{timestamp};
        }

        if ( $elapsed > 280 ) {

            # API url param
            $self->{$api}{url} =~ s/(<param>)/$self->{param}/;

            # Output format JSON
            my $format = '?format=json';
            $format = '&format=json' if ( $self->{$api}{url} =~ /\?/ );

            my $req =
                HTTP::Request->new(
                GET => $self->{http} . '://' . $self->{host} . ':' . $self->{port} . $self->{$api}{url} . $format );
            $req->header( 'content-type' => 'application/json' );

            my $ua   = LWP::UserAgent->new;
            my $resp = $ua->request($req);
            if ( $resp->is_success ) {
                $data = decode_json( $resp->decoded_content );
                $data->{timestamp} = time();
                store( $data, $file );
            }
            else {
                print "HTTP GET error code: ",    $resp->code,    "\n";
                print "HTTP GET error message: ", $resp->message, "\n";
                print Dumper $req;
                exit;
            }
        }
        return $data;
    }
    else {
        print "Missing API ($api)  configuration\n";
        exit;
    }
}
