Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaIIPaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:30:21 -0400
Received: from mout.perfora.net ([74.208.4.196]:60062 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbaIIPaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:30:17 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>
Subject: [PATCH 3/3] ARM: tegra: enable sgtl5000 audio
Date: Tue,  9 Sep 2014 17:28:47 +0200
Message-Id: <fafd714e121b4b04b3284de72b0fa02ac2f9577c.1410276224.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410276224.git.marcel@ziswiler.com>
References: <cover.1410276224.git.marcel@ziswiler.com>
X-Provags-ID: V02:K0:Qk3hm76ZlygwbOrTEBbitnaPN1qmchDZ73uuuWDOfl9
 ho+xX37VCXaO8t5sWQIgf9Kgu9prYfH3+pikoFTQei3jFkBZXa
 UxONjd0/yHyAoU8kWdwds5thoGWcwmKjTYEaKKPLqyJC6/suWQ
 0MATS2yvaq2WZiVS0SuKeobYkCqUdIiRnV0uYa4htpDQRohHg5
 MEt2ko+Veby+lZzEu/L+KVr4cwSKLV4/Y0ZjX5CA6JPOMkpTcY
 oFhQYwERf+J6nTitfyiILxuip6u4Wa/Y5uYB1/xxu+VwwdHFcH
 5VHv09VV6+Nb6kZqPR+KVkMMujH+4+QSbdMJgg9l+Ja7c9+jcz
 e0Fzi/0N4tMkk4fexaY9FqrrgAA2zBn3WYDE+OnmdrdRphGZ5E
 ZPzMQsnLNvBAh+SG//fyb/ipvHwNXobyv/YBNxYUnGHO9lQP1Z
 UOOxgig3aIwGjERDck5/BebmimA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NVIDIA Tegra 3 based Apalis T30 and Colibri T30 modules contain a Freescale SGTL5000 analogue audio codec.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
 arch/arm/configs/tegra_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 77d6e94..02233d1 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -210,6 +210,7 @@ CONFIG_SND_SOC_TEGRA_WM8903=y
 CONFIG_SND_SOC_TEGRA_TRIMSLICE=y
 CONFIG_SND_SOC_TEGRA_ALC5632=y
 CONFIG_SND_SOC_TEGRA_MAX98090=y
+CONFIG_SND_SOC_TEGRA_SGTL5000=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_EHCI_HCD=y
-- 
1.9.3

