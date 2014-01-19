Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaASTD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:03:26 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:54160 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbaASTDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:03:21 -0500
Date: Sun, 19 Jan 2014 19:58:46 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 20/24] drm/i2c: tda998x: remove the unused variable
 ca_i2s
Message-ID: <20140119195846.368a44e6@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 324dc13..a2ad2ac 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -671,7 +671,7 @@ static void
 tda998x_configure_audio(struct tda998x_priv *priv,
 		struct drm_display_mode *mode)
 {
-	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
+	uint8_t buf[6], clksel_aip, clksel_fs, cts_n, adiv;
 	uint32_t aclk, n;
 
 	/* Enable audio ports */
@@ -685,7 +685,6 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_fs = AIP_CLKSEL_FS_FS64SPDIF;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
 		aclk = 0;				/* no clock */
-		ca_i2s = 0;
 		break;
 
 	case AFMT_I2S:
@@ -694,7 +693,6 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
 		aclk = 1;				/* clock enable */
-		ca_i2s = CA_I2S_CA_I2S(0);
 		break;
 
 	default:
-- 
1.8.5.3

