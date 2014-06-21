Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaFUImn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 04:42:43 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:35291 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbaFUIml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 04:42:41 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: lustre: fix sparse warnings for static symbols
Date: Sat, 21 Jun 2014 04:42:10 -0400
Message-Id: <1403340130-25356-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:46:20: warning: symbol 'the_ksocklnd' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:49:19: warning: symbol 'ksocknal_ip2iface' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:67:15: warning: symbol 'ksocknal_create_route' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:103:1: warning: symbol 'ksocknal_create_peer' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:218:1: warning: symbol 'ksocknal_unlink_peer_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:248:1: warning: symbol 'ksocknal_get_peer_info' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:323:1: warning: symbol 'ksocknal_associate_route_conn_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:368:1: warning: symbol 'ksocknal_add_route_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:409:1: warning: symbol 'ksocknal_del_route_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:511:1: warning: symbol 'ksocknal_del_peer_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:566:1: warning: symbol 'ksocknal_del_peer' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:624:14: warning: symbol 'ksocknal_get_conn_by_idx' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:661:15: warning: symbol 'ksocknal_choose_scheduler_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:685:1: warning: symbol 'ksocknal_local_ipvec' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:713:1: warning: symbol 'ksocknal_match_peerip' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:745:1: warning: symbol 'ksocknal_select_ips' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:847:1: warning: symbol 'ksocknal_create_routes' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:997:1: warning: symbol 'ksocknal_connecting' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:1853:1: warning: symbol 'ksocknal_push_peer' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:1886:1: warning: symbol 'ksocknal_push' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:1935:1: warning: symbol 'ksocknal_add_interface' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:1997:1: warning: symbol 'ksocknal_peer_del_interface_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2038:1: warning: symbol 'ksocknal_del_interface' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2213:1: warning: symbol 'ksocknal_free_buffers' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2256:1: warning: symbol 'ksocknal_base_shutdown' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2349:1: warning: symbol 'ksocknal_new_incarnation' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2364:1: warning: symbol 'ksocknal_base_startup' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2496:1: warning: symbol 'ksocknal_debug_peerhash' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2603:1: warning: symbol 'ksocknal_enumerate_interfaces' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2660:1: warning: symbol 'ksocknal_search_new_ipif' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2702:1: warning: symbol 'ksocknal_start_schedulers' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2748:1: warning: symbol 'ksocknal_net_start_threads' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2860:1: warning: symbol 'ksocknal_module_fini' was not declared. Should it be static?
drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c:2866:1: warning: symbol 'ksocknal_module_init' was not declared. Should it be static?

Signed-off-by: James A Shackleford <shack@linux.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   70 ++++++++++----------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index f528b65..425c0fb 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -43,10 +43,10 @@
 
 #include "socklnd.h"
 
-lnd_t		   the_ksocklnd;
-ksock_nal_data_t	ksocknal_data;
+static lnd_t the_ksocklnd;
+ksock_nal_data_t ksocknal_data;
 
-ksock_interface_t *
+static ksock_interface_t *
 ksocknal_ip2iface(lnet_ni_t *ni, __u32 ip)
 {
 	ksock_net_t       *net = ni->ni_data;
@@ -64,7 +64,7 @@ ksocknal_ip2iface(lnet_ni_t *ni, __u32 ip)
 	return NULL;
 }
 
-ksock_route_t *
+static ksock_route_t *
 ksocknal_create_route (__u32 ipaddr, int port)
 {
 	ksock_route_t *route;
@@ -99,7 +99,7 @@ ksocknal_destroy_route (ksock_route_t *route)
 	LIBCFS_FREE (route, sizeof (*route));
 }
 
-int
+static int
 ksocknal_create_peer (ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
 {
 	ksock_net_t   *net = ni->ni_data;
@@ -214,7 +214,7 @@ ksocknal_find_peer (lnet_ni_t *ni, lnet_process_id_t id)
 	return peer;
 }
 
-void
+static void
 ksocknal_unlink_peer_locked (ksock_peer_t *peer)
 {
 	int		i;
@@ -244,7 +244,7 @@ ksocknal_unlink_peer_locked (ksock_peer_t *peer)
 	ksocknal_peer_decref(peer);
 }
 
-int
+static int
 ksocknal_get_peer_info (lnet_ni_t *ni, int index,
 			lnet_process_id_t *id, __u32 *myip, __u32 *peer_ip,
 			int *port, int *conn_count, int *share_count)
@@ -319,7 +319,7 @@ ksocknal_get_peer_info (lnet_ni_t *ni, int index,
 	return rc;
 }
 
-void
+static void
 ksocknal_associate_route_conn_locked(ksock_route_t *route, ksock_conn_t *conn)
 {
 	ksock_peer_t      *peer = route->ksnr_peer;
@@ -364,7 +364,7 @@ ksocknal_associate_route_conn_locked(ksock_route_t *route, ksock_conn_t *conn)
 	route->ksnr_retry_interval = 0;
 }
 
-void
+static void
 ksocknal_add_route_locked (ksock_peer_t *peer, ksock_route_t *route)
 {
 	struct list_head	*tmp;
@@ -405,7 +405,7 @@ ksocknal_add_route_locked (ksock_peer_t *peer, ksock_route_t *route)
 	}
 }
 
-void
+static void
 ksocknal_del_route_locked (ksock_route_t *route)
 {
 	ksock_peer_t      *peer = route->ksnr_peer;
@@ -507,7 +507,7 @@ ksocknal_add_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
 	return 0;
 }
 
-void
+static void
 ksocknal_del_peer_locked (ksock_peer_t *peer, __u32 ip)
 {
 	ksock_conn_t     *conn;
@@ -562,7 +562,7 @@ ksocknal_del_peer_locked (ksock_peer_t *peer, __u32 ip)
 	/* NB peer unlinks itself when last conn/route is removed */
 }
 
-int
+static int
 ksocknal_del_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ip)
 {
 	LIST_HEAD     (zombies);
@@ -621,7 +621,7 @@ ksocknal_del_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ip)
 	return rc;
 }
 
-ksock_conn_t *
+static ksock_conn_t *
 ksocknal_get_conn_by_idx (lnet_ni_t *ni, int index)
 {
 	ksock_peer_t      *peer;
@@ -658,7 +658,7 @@ ksocknal_get_conn_by_idx (lnet_ni_t *ni, int index)
 	return NULL;
 }
 
-ksock_sched_t *
+static ksock_sched_t *
 ksocknal_choose_scheduler_locked(unsigned int cpt)
 {
 	struct ksock_sched_info	*info = ksocknal_data.ksnd_sched_info[cpt];
@@ -681,7 +681,7 @@ ksocknal_choose_scheduler_locked(unsigned int cpt)
 	return sched;
 }
 
-int
+static int
 ksocknal_local_ipvec (lnet_ni_t *ni, __u32 *ipaddrs)
 {
 	ksock_net_t       *net = ni->ni_data;
@@ -709,7 +709,7 @@ ksocknal_local_ipvec (lnet_ni_t *ni, __u32 *ipaddrs)
 	return nip;
 }
 
-int
+static int
 ksocknal_match_peerip (ksock_interface_t *iface, __u32 *ips, int nips)
 {
 	int   best_netmatch = 0;
@@ -741,7 +741,7 @@ ksocknal_match_peerip (ksock_interface_t *iface, __u32 *ips, int nips)
 	return best;
 }
 
-int
+static int
 ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 {
 	rwlock_t		*global_lock = &ksocknal_data.ksnd_global_lock;
@@ -843,7 +843,7 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 	return n_ips;
 }
 
-void
+static void
 ksocknal_create_routes(ksock_peer_t *peer, int port,
 		       __u32 *peer_ipaddrs, int npeer_ipaddrs)
 {
@@ -993,7 +993,7 @@ ksocknal_accept (lnet_ni_t *ni, socket_t *sock)
 	return 0;
 }
 
-int
+static int
 ksocknal_connecting (ksock_peer_t *peer, __u32 ipaddr)
 {
 	ksock_route_t   *route;
@@ -1849,7 +1849,7 @@ ksocknal_query (lnet_ni_t *ni, lnet_nid_t nid, cfs_time_t *when)
 	return;
 }
 
-void
+static void
 ksocknal_push_peer (ksock_peer_t *peer)
 {
 	int	       index;
@@ -1882,7 +1882,7 @@ ksocknal_push_peer (ksock_peer_t *peer)
 	}
 }
 
-int
+static int
 ksocknal_push (lnet_ni_t *ni, lnet_process_id_t id)
 {
 	ksock_peer_t      *peer;
@@ -1931,7 +1931,7 @@ ksocknal_push (lnet_ni_t *ni, lnet_process_id_t id)
 	return rc;
 }
 
-int
+static int
 ksocknal_add_interface(lnet_ni_t *ni, __u32 ipaddress, __u32 netmask)
 {
 	ksock_net_t       *net = ni->ni_data;
@@ -1993,7 +1993,7 @@ ksocknal_add_interface(lnet_ni_t *ni, __u32 ipaddress, __u32 netmask)
 	return rc;
 }
 
-void
+static void
 ksocknal_peer_del_interface_locked(ksock_peer_t *peer, __u32 ipaddr)
 {
 	struct list_head	 *tmp;
@@ -2034,7 +2034,7 @@ ksocknal_peer_del_interface_locked(ksock_peer_t *peer, __u32 ipaddr)
 	}
 }
 
-int
+static int
 ksocknal_del_interface(lnet_ni_t *ni, __u32 ipaddress)
 {
 	ksock_net_t       *net = ni->ni_data;
@@ -2209,7 +2209,7 @@ ksocknal_ctl(lnet_ni_t *ni, unsigned int cmd, void *arg)
 	/* not reached */
 }
 
-void
+static void
 ksocknal_free_buffers (void)
 {
 	LASSERT (atomic_read(&ksocknal_data.ksnd_nactive_txs) == 0);
@@ -2252,7 +2252,7 @@ ksocknal_free_buffers (void)
 	}
 }
 
-void
+static void
 ksocknal_base_shutdown(void)
 {
 	struct ksock_sched_info *info;
@@ -2345,7 +2345,7 @@ ksocknal_base_shutdown(void)
 	module_put(THIS_MODULE);
 }
 
-__u64
+static __u64
 ksocknal_new_incarnation (void)
 {
 	struct timeval tv;
@@ -2360,7 +2360,7 @@ ksocknal_new_incarnation (void)
 	return (((__u64)tv.tv_sec) * 1000000) + tv.tv_usec;
 }
 
-int
+static int
 ksocknal_base_startup(void)
 {
 	struct ksock_sched_info	*info;
@@ -2492,7 +2492,7 @@ ksocknal_base_startup(void)
 	return -ENETDOWN;
 }
 
-void
+static void
 ksocknal_debug_peerhash (lnet_ni_t *ni)
 {
 	ksock_peer_t	*peer = NULL;
@@ -2599,7 +2599,7 @@ ksocknal_shutdown (lnet_ni_t *ni)
 		ksocknal_base_shutdown();
 }
 
-int
+static int
 ksocknal_enumerate_interfaces(ksock_net_t *net)
 {
 	char      **names;
@@ -2656,7 +2656,7 @@ ksocknal_enumerate_interfaces(ksock_net_t *net)
 	return j;
 }
 
-int
+static int
 ksocknal_search_new_ipif(ksock_net_t *net)
 {
 	int	new_ipif = 0;
@@ -2698,7 +2698,7 @@ ksocknal_search_new_ipif(ksock_net_t *net)
 	return new_ipif;
 }
 
-int
+static int
 ksocknal_start_schedulers(struct ksock_sched_info *info)
 {
 	int	nthrs;
@@ -2744,7 +2744,7 @@ ksocknal_start_schedulers(struct ksock_sched_info *info)
 	return rc;
 }
 
-int
+static int
 ksocknal_net_start_threads(ksock_net_t *net, __u32 *cpts, int ncpts)
 {
 	int	newif = ksocknal_search_new_ipif(net);
@@ -2856,13 +2856,13 @@ ksocknal_startup (lnet_ni_t *ni)
 }
 
 
-void __exit
+static void __exit
 ksocknal_module_fini (void)
 {
 	lnet_unregister_lnd(&the_ksocklnd);
 }
 
-int __init
+static int __init
 ksocknal_module_init (void)
 {
 	int    rc;
-- 
1.7.9.5

