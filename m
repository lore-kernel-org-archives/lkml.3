Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbaF3MHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:07:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52036 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 093/181] usb: qcserial: add additional Sierra Wireless QMI devices
Date: Mon, 30 Jun 2014 13:51:54 +0200
Message-Id: <2ae0cc9835e2da5e77c45586de6a412962ddaf03.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aleksander Morgado <aleksander@aleksander.es>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0ce5fb58564fd85aa8fd2d24209900e2e845317b upstream.

A set of new VID/PIDs retrieved from the out-of-tree GobiNet/GobiSerial
Sierra Wireless drivers.

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Link: http://marc.info/?l=linux-usb&m=140136310027293&w=2
Cc: <stable@vger.kernel.org>	# backport in link above
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/qcserial.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 2029f8f7f53f..3e96d1a9cbdb 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -142,9 +142,15 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x1199, 0x68c0)},	/* Sierra Wireless MC73xx */
 	{DEVICE_SWI(0x1199, 0x901c)},	/* Sierra Wireless EM7700 */
 	{DEVICE_SWI(0x1199, 0x901f)},	/* Sierra Wireless EM7355 */
+	{DEVICE_SWI(0x1199, 0x9040)},	/* Sierra Wireless Modem */
 	{DEVICE_SWI(0x1199, 0x9041)},	/* Sierra Wireless MC7305/MC7355 */
 	{DEVICE_SWI(0x1199, 0x9051)},	/* Netgear AirCard 340U */
+	{DEVICE_SWI(0x1199, 0x9053)},	/* Sierra Wireless Modem */
+	{DEVICE_SWI(0x1199, 0x9054)},	/* Sierra Wireless Modem */
 	{DEVICE_SWI(0x1199, 0x9055)},	/* Netgear AirCard 341U */
+	{DEVICE_SWI(0x1199, 0x9056)},	/* Sierra Wireless Modem */
+	{DEVICE_SWI(0x1199, 0x9060)},	/* Sierra Wireless Modem */
+	{DEVICE_SWI(0x1199, 0x9061)},	/* Sierra Wireless Modem */
 	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a4)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
-- 
2.0.0

