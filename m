Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936843Ab3DJWT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:19:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935612Ab3DJWTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:19:55 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH/RFC 6/6] ARM: shmobile: kzm9g-reference: add DMA channels to the MMCIF DT
Date: Thu, 11 Apr 2013 00:19:49 +0200
Message-Id: <1365632389-2249-7-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:x0m7R77YTyBOQQQxscrabl/zaV1KyQdIhXUhDoOBJst
 5f2c9bIWjtIPO91DpCZ2Z5EPtXY6kA81ftz/4RieK/G5wHfTY0
 z5vZWFNu5ZUjzPSicG7UEA0zPguaCDhjbYRYypu84SITBrgdBC
 7+FOOea0EYIcMaeS4gt7op5wnohAE8+q+4GqHfBz/oO1T95yF8
 a2auHswszqnRRRZAtSnZfZ47oEPuyBaecBz5Tv4PV69xySNZyF
 MiDizl7fnLuWmcKV6ju9UPu/r9B9kwg1kuL91BKYuldxKPUr3B
 Yt+dB7f8+vnSyVB+jzz71sJWEu8TBTsnsNESuhJoU/MsoiZk99
 Numu47e+XJ7sM0IwZ/LSvqjydIEsYw1R/rjTILqVNndwgwnymp
 q5F2/hoCES2EQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MMCIF driver can use DMA for data transfer, add suitable
Device Tree bindings.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
index ed9dd45..e1d0d5d 100644
--- a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
+++ b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
@@ -156,6 +156,9 @@
 	bus-width = <8>;
 	vmmc-supply = <&reg_1p8v>;
 	status = "okay";
+	dmas = <&dma0 0xd1
+		&dma0 0xd2>;
+	dma-names = "tx", "rx";
 };
 
 &sdhi0 {
-- 
1.7.2.5

