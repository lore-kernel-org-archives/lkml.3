Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaKXKyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:54:04 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54994 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbaKXKyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:54:01 -0500
Message-ID: <1416826438.10073.11.camel@x220>
Subject: [PATCH] [media] omap24xx/tcm825x: remove pointless Makefile entry
From: Paul Bolle <pebolle@tiscali.nl>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 11:53:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2014 10:53:58.0755 (UTC) FILETIME=[F325DB30:01D007D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The deprecated omap2 camera drivers were recently removed. Both the
Kconfig symbol VIDEO_TCM825X and the drivers/staging/media/omap24xx
directory are gone. So the Makefile entry that references both is now
pointless. Remove it too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by grepping the tree.

Triggered by commit db85a0403be4 ("[media] omap24xx/tcm825x: remove
deprecated omap2 camera drivers."), which is included in next-20141124.
What happened is that it removed only one of the two Makefile entries
for omap24xx.

 drivers/staging/media/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 97bfef97f838..30fb352fc4a9 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -4,7 +4,6 @@ obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
-obj-$(CONFIG_VIDEO_TCM825X)     += omap24xx/
 obj-$(CONFIG_DVB_MN88472)       += mn88472/
 obj-$(CONFIG_DVB_MN88473)       += mn88473/
 
-- 
1.9.3

