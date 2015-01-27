Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbbA0MwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:52:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34837 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106AbbA0MRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steev Klimaszewski <steev@gentoo.org>, Arnd Bergmann <arnd@arndb.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 009/126] Add USB_EHCI_EXYNOS to multi_v7_defconfig
Date: Tue, 27 Jan 2015 12:15:14 +0000
Message-Id: <1422361031-19364-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steev Klimaszewski <threeway@gmail.com>

commit 007487f1fd43d84f26cda926081ca219a24ecbc4 upstream.

Currently we enable Exynos devices in the multi v7 defconfig, however, when
testing on my ODROID-U3, I noticed that USB was not working.  Enabling this
option causes USB to work, which enables networking support as well since the
ODROID-U3 has networking on the USB bus.

[arnd] Support for odroid-u3 was added in 3.10, so it would be nice to
backport this fix at least that far.

Signed-off-by: Steev Klimaszewski <steev@gentoo.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 534836497998..bc41efcd87c2 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -282,6 +282,7 @@ CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_XHCI_MVEBU=y
 CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_EXYNOS=y
 CONFIG_USB_EHCI_TEGRA=y
 CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_ISP1760_HCD=y
-- 
2.1.4

