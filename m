Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbaJDARj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:17:39 -0400
Received: from mout.perfora.net ([74.208.4.196]:59964 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbaJDARh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:17:37 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 3/3] ARM: tegra: enable sgtl5000 audio
Date: Sat,  4 Oct 2014 02:15:45 +0200
Message-Id: <6bd1e5a958108f4d834015342be6de094dbbeb68.1412381377.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1412381377.git.marcel@ziswiler.com>
References: <cover.1412381377.git.marcel@ziswiler.com>
X-Provags-ID: V02:K0:62+2Oor1tUEBeaayyWavy72kuIgxL+3efcfV4dLBGx9
 bWPvorEySpUY4ykiBpKoVUPSNzVFLeO1hlJQ396qHixU7NEO3n
 HrMoZxXY118cJ/z8k7MdACrzbFuCPO4BmSIwClQx6A/moFZyEI
 Uu8BnxKdzIjwghizy33b11PSS/d+oclTStvlrJgOqcY79dg010
 mzqcMvSvvpXkqtniIhNOaU4OWDPvq287H2miG7ohnIhulyeJeL
 x7HtRfuUzbAlTJJ1axSye8wbSDtw4PByPXrsddXejbbU77GDqe
 6A8+27J8KIrE3AyxAGERs58NOiD56OvxxnPIg2c9ZgDjF9V6dH
 aFBOMFi6sPblhnTjcR2bGiyWUTwUunhJ2v0mJezRlemAptDwJd
 XDUW/yPUY8geQvqNJmQ8GJkW+HUx4N20vvwHX5ndNqnuAKVxSY
 dFD2u
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NVIDIA Tegra 3 based Apalis T30 and Colibri T30 modules contain a Freescale SGTL5000 analogue audio codec.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3:
- Revert to not using simple-audio-card being incompatible with tegra.
- Rebased to for-next.

Changes in v2:
- Using simple-audio-card as suggested by Fabio.

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

