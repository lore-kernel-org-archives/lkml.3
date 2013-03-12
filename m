Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab3CLWhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:37:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab3CLWdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [ 089/100] ARM: mxs_defconfig: Make USB host functional again
Date: Tue, 12 Mar 2013 15:32:14 -0700
Message-Id: <20130312223132.478423554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit f6c49da98dd6eacb85034d21d16e1428e03e190f upstream.

commit 09f6ffde2e (USB: EHCI: fix build error by making ChipIdea host a normal
EHCI driver) introduced CONFIG_USB_EHCI_HCD as a dependency for USB_CHIPIDEA_HOST.

Select CONFIG_USB_EHCI_HCD, so that USB host can be functional again.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/configs/mxs_defconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -118,6 +118,7 @@ CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FONTS=y
 CONFIG_LOGO=y
 CONFIG_USB=y
+CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_CHIPIDEA=y
 CONFIG_USB_CHIPIDEA_HOST=y
 CONFIG_USB_STORAGE=y


