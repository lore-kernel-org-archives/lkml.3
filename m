Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbbANIBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:01:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645AbbANHeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:34:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steev Klimaszewski <steev@gentoo.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.14 42/77] Add USB_EHCI_EXYNOS to multi_v7_defconfig
Date: Tue, 13 Jan 2015 23:23:22 -0800
Message-Id: <20150114072226.583902680@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/multi_v7_defconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -235,6 +235,7 @@ CONFIG_SND_SOC_TEGRA_MAX98090=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_EXYNOS=y
 CONFIG_USB_EHCI_TEGRA=y
 CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_ISP1760_HCD=y


