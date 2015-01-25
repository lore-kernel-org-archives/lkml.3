Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbbAYS3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:29:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbbAYSK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.18 108/183] [media] sound: Update au0828 quirks table
Date: Sun, 25 Jan 2015 10:07:10 -0800
Message-Id: <20150125180814.890719249@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

commit 678fa12fb8e75c6dc1e781a02e3ddbbba7e1a904 upstream.

The au0828 quirks table is currently not in sync with the au0828
media driver.

Syncronize it and put them on the same order as found at au0828
driver, as all the au0828 devices with analog TV need the
same quirks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2827,14 +2827,22 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 }
 
 AU0828_DEVICE(0x2040, 0x7200, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7240, "Hauppauge", "HVR-850"),
 AU0828_DEVICE(0x2040, 0x7210, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x7217, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721b, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721e, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721f, "Hauppauge", "HVR-950Q"),
-AU0828_DEVICE(0x2040, 0x7240, "Hauppauge", "HVR-850"),
 AU0828_DEVICE(0x2040, 0x7280, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x0fd9, 0x0008, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7201, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x2040, 0x7211, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x2040, 0x7281, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x05e1, 0x0480, "Hauppauge", "Woodbury"),
+AU0828_DEVICE(0x2040, 0x8200, "Hauppauge", "Woodbury"),
+AU0828_DEVICE(0x2040, 0x7260, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7213, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 
 /* Digidesign Mbox */
 {


