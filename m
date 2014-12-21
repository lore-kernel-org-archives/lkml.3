Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaLUNaB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 08:30:01 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43906 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaLUN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 08:29:59 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: trivial@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 1/2] doc: usbmon: fix wording "be reading until"
Date: Sun, 21 Dec 2014 05:29:20 -0800
Message-Id: <1419168560-2223-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usbmon documentation uses "be reading until" which is an unusual
wording.  Change it to "read until it" which is more clear.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 Documentation/usb/usbmon.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/usb/usbmon.txt b/Documentation/usb/usbmon.txt
index c42bb9c..be2ccb9 100644
--- a/Documentation/usb/usbmon.txt
+++ b/Documentation/usb/usbmon.txt
@@ -72,7 +72,7 @@ to listen on a single bus, otherwise, to listen on all buses, type:
 
 # cat /sys/kernel/debug/usb/usbmon/0u > /tmp/1.mon.out
 
-This process will be reading until killed. Naturally, the output can be
+This process will read until it is killed. Naturally, the output can be
 redirected to a desirable location. This is preferred, because it is going
 to be quite long.
 
-- 
2.1.4

