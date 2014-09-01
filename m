Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaIAJjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:39:35 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:56671 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaIAJjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:39:31 -0400
X-ASG-Debug-ID: 1409564368-0759e7416b8702240002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Johan Hovold <johan@kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Frans Klaver <fransklaver@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH resend 1/2] usb: serial: xsens_mt: add author and description
Date: Mon, 1 Sep 2014 11:39:21 +0200
X-ASG-Orig-Subj: [PATCH resend 1/2] usb: serial: xsens_mt: add author and description
Message-ID: <1409564362-27571-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1409564369
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9055
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/usb/serial/xsens_mt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/xsens_mt.c b/drivers/usb/serial/xsens_mt.c
index 4841fb5..d500ccd 100644
--- a/drivers/usb/serial/xsens_mt.c
+++ b/drivers/usb/serial/xsens_mt.c
@@ -82,4 +82,6 @@ static struct usb_serial_driver * const serial_drivers[] = {
 
 module_usb_serial_driver(serial_drivers, id_table);
 
+MODULE_AUTHOR("Frans Klaver <frans.klaver@xsens.com>");
+MODULE_DESCRIPTION("USB-serial driver for Xsens motion trackers");
 MODULE_LICENSE("GPL");
-- 
2.1.0

