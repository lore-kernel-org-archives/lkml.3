Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaIJU5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:57:06 -0400
Received: from mout.perfora.net ([74.208.4.196]:51961 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbaIJU5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:57:04 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 2/2] ARM: tegra: enable sgtl5000 audio
Date: Wed, 10 Sep 2014 22:54:56 +0200
Message-Id: <28ee136406ef0a760bfc99c3dba089a6cffb0376.1410362950.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410362950.git.marcel@ziswiler.com>
References: <cover.1410362950.git.marcel@ziswiler.com>
X-Provags-ID: V02:K0:LwJiIg7Mbz9ZJOCzoUKGUKlZy1zPE7bMPMo5fxentCi
 ls+VjxOrdetCD1KAyZAGjIrDzr9/NURiomZUlquuA8TQSS0Z4F
 JPN3YBitovhQdi0o4Quhtv8QJjoVw474OHoA/Z4GkCpQ/nolq5
 c40XE5aVbI+30blOJrHCojvw/jV60CoGDR/TyVjFzMydi8H/Oq
 YXuBZyy2lFqBKGFKYtyljcB+IkQk3JUJELGImKRuA/5wlD8HsS
 5MW/E9aV/wIBwXWcBDeemvSdfMQXieqv07aTZ4kLr9U0buE1W7
 BviJDjtf25/kC3bvWmKJbKqjA7mDXIXyD3deH+w/jO8/S+n34q
 wDgpJaKvptQwYrBNqRaqQhP5s7LPODkEoYlnF3WmM4bTSy4Ve5
 ZlPBDeNeOpkkAF42BWu94PXxgfevy0GunOQ/JunnxLgClCIxr8
 gtIyU
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NVIDIA Tegra 3 based Apalis T30 and Colibri T30 modules contain a Freescale SGTL5000 analogue audio codec.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v2:
- Using simple-audio-card as suggested by Fabio.

 arch/arm/configs/tegra_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 77d6e94..568b6a9 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -210,6 +210,8 @@ CONFIG_SND_SOC_TEGRA_WM8903=y
 CONFIG_SND_SOC_TEGRA_TRIMSLICE=y
 CONFIG_SND_SOC_TEGRA_ALC5632=y
 CONFIG_SND_SOC_TEGRA_MAX98090=y
+CONFIG_SND_SOC_SGTL5000=y
+CONFIG_SND_SIMPLE_CARD=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_EHCI_HCD=y
-- 
1.9.3

