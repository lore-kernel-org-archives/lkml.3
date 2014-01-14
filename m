Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaANBCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:02:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaANA1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 3.10 40/62] ARM: dts: exynos5250: Fix MDMA0 clock number
Date: Mon, 13 Jan 2014 16:27:05 -0800
Message-Id: <20140114002711.601673193@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhilash Kesavan <a.kesavan@samsung.com>

commit 8777539479abd7b3efeb691685415dc2b057d0e0 upstream.

Due to incorrect clock specified in MDMA0 node, using MDMA0 controller
could cause system failures, due to wrong clock being controlled. This
patch fixes this by specifying correct clock.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
[t.figa: Corrected commit message and description.]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5250.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -545,7 +545,7 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x10800000 0x1000>;
 			interrupts = <0 33 0>;
-			clocks = <&clock 271>;
+			clocks = <&clock 346>;
 			clock-names = "apb_pclk";
 			#dma-cells = <1>;
 			#dma-channels = <8>;


