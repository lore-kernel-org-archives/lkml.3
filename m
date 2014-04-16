Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaDPHqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:46:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45990 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754639AbaDPHqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:46:39 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] ARM: berlin: add GPIO support for the BG2Q
Date: Wed, 16 Apr 2014 09:46:33 +0200
Message-Id: <1397634395-7456-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the support for the GPIOs of the Berlin BG2Q. We use the
newly integrated dwapb GPIO driver here.

This applies on top of Alexandre's BG2Q symbol introduction[1] and the dwapb
gpio patch fixing IRQ initialization[2].

[1] https://patchwork.kernel.org/patch/3876141/
[2] https://lkml.org/lkml/2014/4/7/96

Changes since v1:
	- s/gpio-controller@/gpio-port@/ in device tree
	- moved ARCH_REQUIRE_GPIOLIB to ARCH_BERLIN in Kconfig

Antoine Ténart (2):
  ARM: berlin: add the LIBGPIO as a dependency for the BG2Q
  ARM: dts: berlin: add GPIO nodes for the BG2Q

 arch/arm/boot/dts/berlin2q.dtsi | 102 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-berlin/Kconfig    |   1 +
 2 files changed, 103 insertions(+)

-- 
1.8.3.2

