Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbbA1VoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:44:11 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62302 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963AbbA1UhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:37:23 -0500
Date: Wed, 28 Jan 2015 16:11:22 +0100
From: Luis de Bethencourt <luis@debethencourt.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-usb: fix spaces after commas
Message-ID: <20150128151122.GA22122@goodgumbo.baconseed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
---
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 719413b..c901d15 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -84,14 +84,14 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
 
 static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
-	deb_ts("start pid: 0x%04x, feedtype: %d\n", dvbdmxfeed->pid,dvbdmxfeed->type);
-	return dvb_usb_ctrl_feed(dvbdmxfeed,1);
+	deb_ts("start pid: 0x%04x, feedtype: %d\n", dvbdmxfeed->pid, dvbdmxfeed->type);
+	return dvb_usb_ctrl_feed(dvbdmxfeed, 1);
 }
 
 static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
 	deb_ts("stop pid: 0x%04x, feedtype: %d\n", dvbdmxfeed->pid, dvbdmxfeed->type);
-	return dvb_usb_ctrl_feed(dvbdmxfeed,0);
+	return dvb_usb_ctrl_feed(dvbdmxfeed, 0);
 }
 
 int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
@@ -108,8 +108,8 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 	adap->dvb_adap.priv = adap;
 
 	if (adap->dev->props.read_mac_address) {
-		if (adap->dev->props.read_mac_address(adap->dev,adap->dvb_adap.proposed_mac) == 0)
-			info("MAC address: %pM",adap->dvb_adap.proposed_mac);
+		if (adap->dev->props.read_mac_address(adap->dev, adap->dvb_adap.proposed_mac) == 0)
+			info("MAC address: %pM", adap->dvb_adap.proposed_mac);
 		else
 			err("MAC address reading failed.");
 	}
@@ -128,7 +128,7 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 	adap->demux.stop_feed        = dvb_usb_stop_feed;
 	adap->demux.write_to_decoder = NULL;
 	if ((ret = dvb_dmx_init(&adap->demux)) < 0) {
-		err("dvb_dmx_init failed: error %d",ret);
+		err("dvb_dmx_init failed: error %d", ret);
 		goto err_dmx;
 	}
 
@@ -136,13 +136,13 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 	adap->dmxdev.demux           = &adap->demux.dmx;
 	adap->dmxdev.capabilities    = 0;
 	if ((ret = dvb_dmxdev_init(&adap->dmxdev, &adap->dvb_adap)) < 0) {
-		err("dvb_dmxdev_init failed: error %d",ret);
+		err("dvb_dmxdev_init failed: error %d", ret);
 		goto err_dmx_dev;
 	}
 
 	if ((ret = dvb_net_init(&adap->dvb_adap, &adap->dvb_net,
 						&adap->demux.dmx)) < 0) {
-		err("dvb_net_init failed: error %d",ret);
+		err("dvb_net_init failed: error %d", ret);
 		goto err_net_init;
 	}
 
-- 
2.1.3

