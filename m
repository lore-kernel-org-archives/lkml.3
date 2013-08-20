Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab3HTQQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:16:38 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54839 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3HTQQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:16:35 -0400
Subject: [PATCH v3 trivial 3/7] Docs: Kconfig: Clean up the radiotap
                                               documentation
Date: Tue, 20 Aug 2013 16:05:17 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <44c613c35216473d9741d6308d9873ec-mfwitten@gmail.com>
In-Reply-To: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
References: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Fri, 8 Apr 2011 14:18:54 +0000

In particular:

  * The word `frame' was missing in `received frame',
    so it has been added.

  * The `RF' in `a RF' was both superfluous and awkward,
    so it has been removed.

As for the rest of the changes, well, I just couldn't help myself!

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 drivers/net/wireless/ipw2x00/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 5397cd1..5abf297 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -112,13 +112,13 @@ config IPW2200_RADIOTAP
 	depends on IPW2200_MONITOR
 
 config IPW2200_PROMISCUOUS
-	bool "Enable creation of a RF radiotap promiscuous interface"
+	bool "Enable creation of a radiotap promiscuous interface"
 	depends on IPW2200_MONITOR
 	select IPW2200_RADIOTAP
 	---help---
-	  Enables the creation of a second interface prefixed 'rtap'.
-	  This second interface will provide every received in radiotap
-	  format.
+	  Enables the creation of a second interface (the name of which
+	  is prefixed with 'rtap'), which provides every received frame
+	  in radiotap format.
 
 	  This is useful for performing wireless network analysis while
 	  maintaining an active association.
@@ -129,9 +129,9 @@ config IPW2200_PROMISCUOUS
 	    % ifconfig rtap0 up
 	    % tethereal -i rtap0
 
-	  If you do not specify 'rtap_iface=1' as a module parameter then
-	  the rtap interface will not be created and you will need to turn
-	  it on via sysfs:
+	  If you do not specify 'rtap_iface=1' as a module parameter, then
+	  the rtap interface will not be created automatically, but it can
+	  still be created via sysfs:
 
 	    % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
 
-- 
1.7.11.2.252.gc4a64c8

