Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaAILMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:12:38 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:40958 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbaAILMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:12:33 -0500
Date: Thu, 9 Jan 2014 12:06:30 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 22/28] drm/i2c: tda998x: remove the unused variable
 ca_i2s
Message-ID: <20140109120630.61a65a8a@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index efd29d1..55cecb8 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -718,7 +718,7 @@ static void
 tda998x_configure_audio(struct tda998x_priv *priv,
 		struct drm_display_mode *mode)
 {
-	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
+	uint8_t buf[6], clksel_aip, clksel_fs, cts_n, adiv;
 	uint32_t n;
 
 	/* Enable audio ports */
@@ -732,7 +732,6 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP(SEL_AIP_SPDIF);
 		clksel_fs = AIP_CLKSEL_FS(CTSREF_FS64SPDIF);
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
-		ca_i2s = 0;
 		break;
 
 	case AFMT_I2S:
@@ -740,7 +739,6 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP(SEL_AIP_I2S);
 		clksel_fs = AIP_CLKSEL_FS(CTSREF_ACLK);
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
-		ca_i2s = CA_I2S_CA_I2S(0);
 		break;
 
 	default:
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
