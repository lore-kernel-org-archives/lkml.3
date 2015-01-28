Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbbA2JDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:03:38 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44797 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758893AbbA2JDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:03:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steev Klimaszewski <threeway@gmail.com>,
        Steev Klimaszewski <steev@gentoo.org>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 033/176] Add USB_EHCI_EXYNOS to multi_v7_defconfig
Date: Wed, 28 Jan 2015 15:27:43 +0100
Message-Id: <d379dec78e7c15ca987166092114094c8aea4b0a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steev Klimaszewski <threeway@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 007487f1fd43d84f26cda926081ca219a24ecbc4 upstream.

Currently we enable Exynos devices in the multi v7 defconfig, however, when
testing on my ODROID-U3, I noticed that USB was not working.  Enabling this
option causes USB to work, which enables networking support as well since the
ODROID-U3 has networking on the USB bus.

[arnd] Support for odroid-u3 was added in 3.10, so it would be nice to
backport this fix at least that far.

Signed-off-by: Steev Klimaszewski <steev@gentoo.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index fe88105a0421..f8bca690569d 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -116,6 +116,7 @@ CONFIG_FB_SIMPLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_EXYNOS=y
 CONFIG_USB_EHCI_TEGRA=y
 CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_ISP1760_HCD=y
-- 
2.2.2

