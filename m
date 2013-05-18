Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3ERCaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:30:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3ERCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:46 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=z9qVf-kBTGEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uDenMY93LsAA:10 a=HS1nej8rAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=bd4f5bPjUsAGqL3yVJwA:9 a=jbfNj8WeVEAA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021643.706988781@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Jencks <ben@bjencks.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 012/136 ] usb/misc/appledisplay: Add 24" LED Cinema display
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0012-usb-misc-appledisplay-Add-24-LED-Cinema-display.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ben Jencks <ben@bjencks.net>

[ Upstream commit e7d3b6e22c871ba36d052ca99bc8ceca4d546a60 ]

Add the Apple 24" LED Cinema display to the supported devices.

Signed-off-by: Ben Jencks <ben@bjencks.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/misc/appledisplay.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 0fc6e5f..ba6a5d6 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -63,6 +63,7 @@ static const struct usb_device_id appledisplay_table[] = {
 	{ APPLEDISPLAY_DEVICE(0x9219) },
 	{ APPLEDISPLAY_DEVICE(0x921c) },
 	{ APPLEDISPLAY_DEVICE(0x921d) },
+	{ APPLEDISPLAY_DEVICE(0x9236) },
 
 	/* Terminating entry */
 	{ }
-- 
1.7.10.4


