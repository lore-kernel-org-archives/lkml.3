Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaHTEbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:31:47 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:42288 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaHTEbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:31:34 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com, max@vozeler.com,
        shuahkhan@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 4/4] MAINTAINERS: Add an entry for USB/IP driver
Date: Wed, 20 Aug 2014 07:31:02 +0300
Message-Id: <1408509062-1375-5-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1408509062-1375-1-git-send-email-valentina.manea.m@gmail.com>
References: <1408509062-1375-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an entry in MAINTAINERS file for USB/IP
driver.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aefa948..76ac03d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9515,6 +9515,14 @@ S:	Maintained
 F:	Documentation/usb/ohci.txt
 F:	drivers/usb/host/ohci*
 
+USB OVER IP DRIVER
+M:	Valentina Manea <valentina.manea.m@gmail.com>
+M:	Shuah Khan <shuah.kh@samsung.com>
+L:	linux-usb@vger.kernel.org
+S:	Maintained
+F:	drivers/usb/usbip/
+F:	tools/usb/usbip/
+
 USB PEGASUS DRIVER
 M:	Petko Manolov <petkan@nucleusys.com>
 L:	linux-usb@vger.kernel.org
-- 
1.8.1.2

