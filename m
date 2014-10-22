Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbaJVJir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:38:47 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:42040 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbaJVJij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:38:39 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/3] ARM: shmobile: armadillo800eva dts: Enable TMU0
Date: Wed, 22 Oct 2014 11:38:29 +0200
Message-Id: <1413970709-26607-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ch0 will be used for clock events and for periodic clock events,
ch1 will be used as clock source.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7740-armadillo800eva.dts b/arch/arm/boot/dts/r8a7740-armadillo800eva.dts
index 2703428557fce9fa..98504e0b06c8e2ca 100644
--- a/arch/arm/boot/dts/r8a7740-armadillo800eva.dts
+++ b/arch/arm/boot/dts/r8a7740-armadillo800eva.dts
@@ -299,3 +299,7 @@
 
 	status = "okay";
 };
+
+&tmu0 {
+	status = "okay";
+};
-- 
1.9.1

