Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaAILP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:15:56 -0500
Received: from mail-pb0-f66.google.com ([209.85.160.66]:39622 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaAILMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:12:03 -0500
From: me@anmolsarma.in
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anmol Sarma <me@anmolsarma.in>
Subject: [PATCH 3/3] Staging: rtl8187se: ieee80211: ieee80211_softmac.c: mark symbols as static
Date: Thu,  9 Jan 2014 16:41:07 +0530
Message-Id: <9036792bea27cf00f564bbcb72f19de6b450f4a3.1389263965.git.me@anmolsarma.in>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1389263965.git.me@anmolsarma.in>
References: <cover.1389263965.git.me@anmolsarma.in>
In-Reply-To: <cover.1389263965.git.me@anmolsarma.in>
References: <cover.1389263965.git.me@anmolsarma.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anmol Sarma <me@anmolsarma.in>

Fixes the following sparse warnings:
50:14: warning: symbol 'ieee80211_MFIE_rate_len' was not declared. Should it be
static?
68:6: warning: symbol 'ieee80211_MFIE_Brate' was not declared. Should it be
static?
85:6: warning: symbol 'ieee80211_MFIE_Grate' was not declared. Should it be
static?
109:6: warning: symbol 'ieee80211_WMM_Info' was not declared. Should it be
static?
132:6: warning: symbol 'ieee80211_TURBO_Info' was not declared. Should it be
static?
148:6: warning: symbol 'enqueue_mgmt' was not declared. Should it be static?
166:16: warning: symbol 'dequeue_mgmt' was not declared. Should it be static?
181:6: warning: symbol 'init_mgmt_queue' was not declared. Should it be static?
377:6: warning: symbol 'ieee80211_send_beacon' was not declared. Should it be
static?
402:6: warning: symbol 'ieee80211_send_beacon_cb' was not declared. Should it be
static?
413:6: warning: symbol 'ieee80211_send_probe' was not declared. Should it be
static?
425:6: warning: symbol 'ieee80211_send_probe_requests' was not declared. Should
it be static?
436:6: warning: symbol 'ieee80211_softmac_scan_syncro' was not declared. Should
it be static?
574:6: warning: symbol 'ieee80211_softmac_scan_wq' was not declared. Should it
be static?
617:6: warning: symbol 'ieee80211_beacons_start' was not declared. Should it be
static?
629:6: warning: symbol 'ieee80211_beacons_stop' was not declared. Should it be
static?
661:6: warning: symbol 'ieee80211_softmac_stop_scan' was not declared. Should it
be static?
969:16: warning: symbol 'ieee80211_null_func' was not declared. Should it be
static?
995:6: warning: symbol 'ieee80211_resp_to_assoc_rq' was not declared. Should it
be static?
1006:6: warning: symbol 'ieee80211_resp_to_auth' was not declared. Should it be
static?
1017:6: warning: symbol 'ieee80211_resp_to_probe' was not declared. Should it be
static?
1166:6: warning: symbol 'ieee80211_associate_abort_cb' was not declared. Should
it be static?
1172:6: warning: symbol 'ieee80211_associate_step1' was not declared. Should it
be static?
1202:6: warning: symbol 'ieee80211_rtl_auth_challenge' was not declared. Should
it be static?
1237:6: warning: symbol 'ieee80211_associate_step2' was not declared. Should it
be static?
1259:6: warning: symbol 'ieee80211_associate_complete_wq' was not declared.
Should it be
static?
1280:6: warning: symbol 'ieee80211_associate_complete' was not declared. Should
it be static?
1294:6: warning: symbol 'ieee80211_associate_procedure_wq' was not declared.
Should it be static?
1453:5: warning: symbol 'auth_rq_parse' was not declared. Should it be static?
1510:5: warning: symbol 'assoc_rq_parse' was not declared. Should it be static?
1600:7: warning: symbol 'ieee80211_sta_ps_sleep' was not declared. Should it be
static?
2020:6: warning: symbol 'ieee80211_resume_tx' was not declared. Should it be
static?
2150:6: warning: symbol 'ieee80211_start_monitor_mode' was not declared. Should
it be static?
2161:6: warning: symbol 'ieee80211_start_ibss_wq' was not declared. Should it be
static?
2334:6: warning: symbol 'ieee80211_associate_retry_wq' was not declared. Should
it be static?
2626:6: warning: symbol 'ieee80211_wpa_assoc_frame' was not declared. Should it
be static?
1654:13: warning: symbol 'ieee80211_sta_ps' was not declared. Should it be
static?

Signed-off-by: Anmol Sarma <me@anmolsarma.in>
---
 .../rtl8187se/ieee80211/ieee80211_softmac.c        | 74 +++++++++++-----------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 3af1bf9..c27392d 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -47,7 +47,7 @@ short ieee80211_is_shortslot(const struct ieee80211_network *net)
  * tag and the EXTENDED RATE MFIE tag if needed.
  * It encludes two bytes per tag for the tag itself and its len
  */
-unsigned int ieee80211_MFIE_rate_len(struct ieee80211_device *ieee)
+static unsigned int ieee80211_MFIE_rate_len(struct ieee80211_device *ieee)
 {
 	unsigned int rate_len = 0;
 
@@ -65,7 +65,7 @@ unsigned int ieee80211_MFIE_rate_len(struct ieee80211_device *ieee)
  * Then it updates the pointer so that
  * it points after the new MFIE tag added.
  */
-void ieee80211_MFIE_Brate(struct ieee80211_device *ieee, u8 **tag_p)
+static void ieee80211_MFIE_Brate(struct ieee80211_device *ieee, u8 **tag_p)
 {
 	u8 *tag = *tag_p;
 
@@ -82,7 +82,7 @@ void ieee80211_MFIE_Brate(struct ieee80211_device *ieee, u8 **tag_p)
 	*tag_p = tag;
 }
 
-void ieee80211_MFIE_Grate(struct ieee80211_device *ieee, u8 **tag_p)
+static void ieee80211_MFIE_Grate(struct ieee80211_device *ieee, u8 **tag_p)
 {
 	u8 *tag = *tag_p;
 
@@ -106,7 +106,7 @@ void ieee80211_MFIE_Grate(struct ieee80211_device *ieee, u8 **tag_p)
 }
 
 
-void ieee80211_WMM_Info(struct ieee80211_device *ieee, u8 **tag_p)
+static void ieee80211_WMM_Info(struct ieee80211_device *ieee, u8 **tag_p)
 {
 	u8 *tag = *tag_p;
 
@@ -129,7 +129,7 @@ void ieee80211_WMM_Info(struct ieee80211_device *ieee, u8 **tag_p)
 	*tag_p = tag;
 }
 
-void ieee80211_TURBO_Info(struct ieee80211_device *ieee, u8 **tag_p)
+static void ieee80211_TURBO_Info(struct ieee80211_device *ieee, u8 **tag_p)
 {
 	u8 *tag = *tag_p;
 	*tag++ = MFIE_TYPE_GENERIC; /* 0 */
@@ -145,7 +145,7 @@ void ieee80211_TURBO_Info(struct ieee80211_device *ieee, u8 **tag_p)
 	printk(KERN_ALERT "This is enable turbo mode IE process\n");
 }
 
-void enqueue_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb)
+static void enqueue_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb)
 {
 	int nh;
 	nh = (ieee->mgmt_queue_head +1) % MGMT_QUEUE_NUM;
@@ -163,7 +163,7 @@ void enqueue_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb)
 	//return 0;
 }
 
-struct sk_buff *dequeue_mgmt(struct ieee80211_device *ieee)
+static struct sk_buff *dequeue_mgmt(struct ieee80211_device *ieee)
 {
 	struct sk_buff *ret;
 
@@ -178,7 +178,7 @@ struct sk_buff *dequeue_mgmt(struct ieee80211_device *ieee)
 	return ret;
 }
 
-void init_mgmt_queue(struct ieee80211_device *ieee)
+static void init_mgmt_queue(struct ieee80211_device *ieee)
 {
 	ieee->mgmt_queue_tail = ieee->mgmt_queue_head = 0;
 }
@@ -374,7 +374,7 @@ void ext_ieee80211_send_beacon_wq(struct ieee80211_device *ieee)
 	//spin_unlock_irqrestore(&ieee->beacon_lock,flags);
 }
 
-void ieee80211_send_beacon(struct ieee80211_device *ieee)
+static void ieee80211_send_beacon(struct ieee80211_device *ieee)
 {
 	struct sk_buff *skb;
 
@@ -399,7 +399,7 @@ void ieee80211_send_beacon(struct ieee80211_device *ieee)
 }
 
 
-void ieee80211_send_beacon_cb(unsigned long _ieee)
+static void ieee80211_send_beacon_cb(unsigned long _ieee)
 {
 	struct ieee80211_device *ieee =
 		(struct ieee80211_device *) _ieee;
@@ -410,7 +410,7 @@ void ieee80211_send_beacon_cb(unsigned long _ieee)
 	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
 }
 
-void ieee80211_send_probe(struct ieee80211_device *ieee)
+static void ieee80211_send_probe(struct ieee80211_device *ieee)
 {
 	struct sk_buff *skb;
 
@@ -422,7 +422,7 @@ void ieee80211_send_probe(struct ieee80211_device *ieee)
 	}
 }
 
-void ieee80211_send_probe_requests(struct ieee80211_device *ieee)
+static void ieee80211_send_probe_requests(struct ieee80211_device *ieee)
 {
 	if (ieee->active_scan && (ieee->softmac_features & IEEE_SOFTMAC_PROBERQ)){
 		ieee80211_send_probe(ieee);
@@ -433,7 +433,7 @@ void ieee80211_send_probe_requests(struct ieee80211_device *ieee)
 /* this performs syncro scan blocking the caller until all channels
  * in the allowed channel map has been checked.
  */
-void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
+static void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 {
 	short ch = 0;
 	u8 channel_map[MAX_CHANNEL_NUMBER+1];
@@ -571,7 +571,7 @@ out:
 		DOT11D_ScanComplete(ieee);
 }
 
-void ieee80211_softmac_scan_wq(struct work_struct *work)
+static void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, softmac_scan_wq);
@@ -614,7 +614,7 @@ out:
 	return;
 }
 
-void ieee80211_beacons_start(struct ieee80211_device *ieee)
+static void ieee80211_beacons_start(struct ieee80211_device *ieee)
 {
 	unsigned long flags;
 
@@ -626,7 +626,7 @@ void ieee80211_beacons_start(struct ieee80211_device *ieee)
 	spin_unlock_irqrestore(&ieee->beacon_lock,flags);
 }
 
-void ieee80211_beacons_stop(struct ieee80211_device *ieee)
+static void ieee80211_beacons_stop(struct ieee80211_device *ieee)
 {
 	unsigned long flags;
 
@@ -658,7 +658,7 @@ void ieee80211_start_send_beacons(struct ieee80211_device *ieee)
 }
 
 
-void ieee80211_softmac_stop_scan(struct ieee80211_device *ieee)
+static void ieee80211_softmac_stop_scan(struct ieee80211_device *ieee)
 {
 //	unsigned long flags;
 
@@ -966,7 +966,7 @@ static struct sk_buff *ieee80211_auth_resp(struct ieee80211_device *ieee,
 
 }
 
-struct sk_buff *ieee80211_null_func(struct ieee80211_device *ieee, short pwr)
+static struct sk_buff *ieee80211_null_func(struct ieee80211_device *ieee, short pwr)
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr_3addr* hdr;
@@ -992,7 +992,7 @@ struct sk_buff *ieee80211_null_func(struct ieee80211_device *ieee, short pwr)
 }
 
 
-void ieee80211_resp_to_assoc_rq(struct ieee80211_device *ieee, u8 *dest)
+static void ieee80211_resp_to_assoc_rq(struct ieee80211_device *ieee, u8 *dest)
 {
 	struct sk_buff *buf = ieee80211_assoc_resp(ieee, dest);
 
@@ -1003,7 +1003,7 @@ void ieee80211_resp_to_assoc_rq(struct ieee80211_device *ieee, u8 *dest)
 }
 
 
-void ieee80211_resp_to_auth(struct ieee80211_device *ieee, int s, u8 *dest)
+static void ieee80211_resp_to_auth(struct ieee80211_device *ieee, int s, u8 *dest)
 {
 	struct sk_buff *buf = ieee80211_auth_resp(ieee, s, dest);
 
@@ -1014,7 +1014,7 @@ void ieee80211_resp_to_auth(struct ieee80211_device *ieee, int s, u8 *dest)
 }
 
 
-void ieee80211_resp_to_probe(struct ieee80211_device *ieee, u8 *dest)
+static void ieee80211_resp_to_probe(struct ieee80211_device *ieee, u8 *dest)
 {
 
 	struct sk_buff *buf = ieee80211_probe_resp(ieee, dest);
@@ -1163,13 +1163,13 @@ void ieee80211_associate_abort(struct ieee80211_device *ieee)
 	spin_unlock_irqrestore(&ieee->lock, flags);
 }
 
-void ieee80211_associate_abort_cb(unsigned long dev)
+static void ieee80211_associate_abort_cb(unsigned long dev)
 {
 	ieee80211_associate_abort((struct ieee80211_device *) dev);
 }
 
 
-void ieee80211_associate_step1(struct ieee80211_device *ieee)
+static void ieee80211_associate_step1(struct ieee80211_device *ieee)
 {
 	struct ieee80211_network *beacon = &ieee->current_network;
 	struct sk_buff *skb;
@@ -1199,7 +1199,7 @@ void ieee80211_associate_step1(struct ieee80211_device *ieee)
 	}
 }
 
-void ieee80211_rtl_auth_challenge(struct ieee80211_device *ieee, u8 *challenge,
+static void ieee80211_rtl_auth_challenge(struct ieee80211_device *ieee, u8 *challenge,
 				  int chlen)
 {
 	u8 *c;
@@ -1234,7 +1234,7 @@ void ieee80211_rtl_auth_challenge(struct ieee80211_device *ieee, u8 *challenge,
 	kfree(challenge);
 }
 
-void ieee80211_associate_step2(struct ieee80211_device *ieee)
+static void ieee80211_associate_step2(struct ieee80211_device *ieee)
 {
 	struct sk_buff* skb;
 	struct ieee80211_network *beacon = &ieee->current_network;
@@ -1256,7 +1256,7 @@ void ieee80211_associate_step2(struct ieee80211_device *ieee)
 	}
 }
 
-void ieee80211_associate_complete_wq(struct work_struct *work)
+static void ieee80211_associate_complete_wq(struct work_struct *work)
 {
 	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, associate_complete_wq);
 
@@ -1277,7 +1277,7 @@ void ieee80211_associate_complete_wq(struct work_struct *work)
 	netif_carrier_on(ieee->dev);
 }
 
-void ieee80211_associate_complete(struct ieee80211_device *ieee)
+static void ieee80211_associate_complete(struct ieee80211_device *ieee)
 {
 	int i;
 	del_timer_sync(&ieee->associate_timer);
@@ -1291,7 +1291,7 @@ void ieee80211_associate_complete(struct ieee80211_device *ieee)
 	queue_work(ieee->wq, &ieee->associate_complete_wq);
 }
 
-void ieee80211_associate_procedure_wq(struct work_struct *work)
+static void ieee80211_associate_procedure_wq(struct work_struct *work)
 {
 	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, associate_procedure_wq);
 
@@ -1450,7 +1450,7 @@ static inline u16 auth_parse(struct sk_buff *skb, u8 **challenge, int *chlen)
 }
 
 
-int auth_rq_parse(struct sk_buff *skb, u8 *dest)
+static int auth_rq_parse(struct sk_buff *skb, u8 *dest)
 {
 	struct ieee80211_authentication *a;
 
@@ -1507,7 +1507,7 @@ static short probe_rq_parse(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 }
 
-int assoc_rq_parse(struct sk_buff *skb, u8 *dest)
+static int assoc_rq_parse(struct sk_buff *skb, u8 *dest)
 {
 	struct ieee80211_assoc_request_frame *a;
 
@@ -1597,7 +1597,7 @@ void ieee80211_sta_ps_send_null_frame(struct ieee80211_device *ieee, short pwr)
 }
 
 
-short ieee80211_sta_ps_sleep(struct ieee80211_device *ieee, u32 *time_h,
+static short ieee80211_sta_ps_sleep(struct ieee80211_device *ieee, u32 *time_h,
 			     u32 *time_l)
 {
         int timeout = 0;
@@ -1651,7 +1651,7 @@ short ieee80211_sta_ps_sleep(struct ieee80211_device *ieee, u32 *time_h,
 
 }
 
-inline void ieee80211_sta_ps(struct ieee80211_device *ieee)
+static inline void ieee80211_sta_ps(struct ieee80211_device *ieee)
 {
 
 	u32 th,tl;
@@ -2017,7 +2017,7 @@ void ieee80211_softmac_xmit(struct ieee80211_txb *txb,
 }
 
 /* called with ieee->lock acquired */
-void ieee80211_resume_tx(struct ieee80211_device *ieee)
+static void ieee80211_resume_tx(struct ieee80211_device *ieee)
 {
 	int i;
 	for(i = ieee->tx_pending.frag; i < ieee->tx_pending.txb->nr_frags; i++) {
@@ -2147,7 +2147,7 @@ void ieee80211_start_master_bss(struct ieee80211_device *ieee)
 	netif_carrier_on(ieee->dev);
 }
 
-void ieee80211_start_monitor_mode(struct ieee80211_device *ieee)
+static void ieee80211_start_monitor_mode(struct ieee80211_device *ieee)
 {
 	if(ieee->raw_tx){
 
@@ -2158,7 +2158,7 @@ void ieee80211_start_monitor_mode(struct ieee80211_device *ieee)
 	}
 }
 
-void ieee80211_start_ibss_wq(struct work_struct *work)
+static void ieee80211_start_ibss_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, start_ibss_wq);
@@ -2331,7 +2331,7 @@ void ieee80211_disassociate(struct ieee80211_device *ieee)
 	ieee->state = IEEE80211_NOLINK;
 
 }
-void ieee80211_associate_retry_wq(struct work_struct *work)
+static void ieee80211_associate_retry_wq(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, associate_retry_wq);
@@ -2623,7 +2623,7 @@ static int ieee80211_wpa_enable(struct ieee80211_device *ieee, int value)
 }
 
 
-void ieee80211_wpa_assoc_frame(struct ieee80211_device *ieee, char *wpa_ie,
+static void ieee80211_wpa_assoc_frame(struct ieee80211_device *ieee, char *wpa_ie,
 			       int wpa_ie_len)
 {
 	/* make sure WPA is enabled */
-- 
1.8.3.2

