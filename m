Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaDOIHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:07:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37912 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbaDOIH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:07:29 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ARM: berlin: add GPIO support for the BG2Q
Date: Tue, 15 Apr 2014 10:07:23 +0200
Message-Id: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
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

Antoine Ténart (2):
  ARM: berlin: add the LIBGPIO as a dependency for the BG2Q
  ARM: dts: berlin: add GPIO nodes for the BG2Q

 arch/arm/boot/dts/berlin2q.dtsi | 102 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-berlin/Kconfig    |   1 +
 2 files changed, 103 insertions(+)

-- 
1.8.3.2

