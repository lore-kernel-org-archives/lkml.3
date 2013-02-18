Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3BRRU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:20:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54713 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab3BRRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:20:55 -0500
From: Tim Niemeyer <tim.niemeyer@corscience.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mans Rullgard <mans@mansr.com>, Thomas Weber <thomas.weber@corscience.de>
Subject: [PATCH] arm: update ARM_ERRATA_430973 Kconfig
Date: Mon, 18 Feb 2013 18:15:04 +0100
Message-Id: <1361207704-11609-1-git-send-email-tim.niemeyer@corscience.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:S1EIjOMusmkDx3fLVJMdvx8ZJqonaeT00tSwy4S/FMI
 soqmMyppbQ1C2IAwFGkWiqqVQaI18UezwJJQ7H8ZQ2ylmspYRo
 cw/rgTqqdVRL1F+CsD6VAp7JVeixc79KAEHNHUSV3WUmO71Y2s
 4RoLTQ3nTi7kdSWjrvWjJPtXsEUBrVcerxrnyJd/YEIxVxFx4w
 IHhMsjxloNLFTYFCHcsDmbI68UxkQo0O9i37Bqbq8TG69a2zJ7
 e+I11RWVy2eVY5/Ich0d9X8x/UKcTqUkMt7q/JgCVs8ua2Ifzs
 Iwh02c+ufLpm38XnIzlA3sZUi6wh04GTrSdTZJ2aUPFR1xI3ig
 Ut+JlkXuLnniTHeI9w7x+rzKd3DAp5+WQE+Sfm5Jq0u2r8n6KT
 qtfiim5i7R9XQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had strange problems with some illegal instructions and segmentation
faults. It turns out that the OMAP3503D (Cortex A8 r1p3) suffers from
erratum 430973.

    Discussion about this problem:
    https://bugs.launchpad.net/ubuntu/+source/fakeroot/+bug/495536
    http://www.beagleboard.org/irclogs/index.php?date=2013-02-18

Signed-off-by: Tim Niemeyer <tim.niemeyer@corscience.de>
Signed-off-by: Thomas Weber <thomas.weber@corscience.de>
---
 arch/arm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 67874b8..2ca277e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1215,7 +1215,7 @@ config ARM_ERRATA_430973
 	depends on CPU_V7
 	help
 	  This option enables the workaround for the 430973 Cortex-A8
-	  (r1p0..r1p2) erratum. If a code sequence containing an ARM/Thumb
+	  (r1p*) erratum. If a code sequence containing an ARM/Thumb
 	  interworking branch is replaced with another code sequence at the
 	  same virtual address, whether due to self-modifying code or virtual
 	  to physical address re-mapping, Cortex-A8 does not recover from the
-- 
1.7.2.5

