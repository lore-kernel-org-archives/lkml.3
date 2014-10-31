Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbaJaQFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:05:05 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52108 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756939AbaJaQFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:05:03 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 1/3] arm64: defconfig: Enable support for generic EHCI and OHCI platforms
Date: Fri, 31 Oct 2014 16:04:18 +0000
Message-Id: <1414771460-7340-2-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414771460-7340-1-git-send-email-Liviu.Dudau@arm.com>
References: <1414771460-7340-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that real arm64 platforms exists and they have standard EHCI and
OHCI USB controllers, enable support for them.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/arm64/configs/defconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 4ce602c..8643e58 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -97,8 +97,13 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_LINUX_MONO is not set
 # CONFIG_LOGO_LINUX_VGA16 is not set
 CONFIG_USB=y
+CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_ISP1760_HCD=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_OHCI_HCD_PLATFORM=y
 CONFIG_USB_STORAGE=y
+CONFIG_USB_ULPI=y
 CONFIG_MMC=y
 CONFIG_MMC_ARMMMCI=y
 CONFIG_VIRTIO_BALLOON=y
-- 
2.1.2

