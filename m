Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbbANIS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:18:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbbANH3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steev Klimaszewski <steev@gentoo.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.18 088/150] Add USB_EHCI_EXYNOS to multi_v7_defconfig
Date: Tue, 13 Jan 2015 23:22:39 -0800
Message-Id: <20150114072059.853268115@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -320,6 +320,7 @@ CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_XHCI_MVEBU=y
 CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_EXYNOS=y
 CONFIG_USB_EHCI_TEGRA=y
 CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_ISP1760_HCD=y


