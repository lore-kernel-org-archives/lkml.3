Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3FGLVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:21:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39327 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3FGLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:21:36 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 0/3] Add display support for Origen board
Date: Fri,  7 Jun 2013 16:37:12 +0530
Message-Id: <1370603235-11193-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches are based in Kukjin's for-next branch.

Sachin Kamat (2):
  ARM: dts: exynos4210: Add LCD related pinctrl entries
  ARM: dts: Add FIMD node to Origen4210 board

Tushar Behera (1):
  ARM: dts: Set BUCK7 as always on for Origen board

 arch/arm/boot/dts/exynos4210-origen.dts   |   22 +++++++++
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi |   75 +++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

-- 
1.7.9.5

