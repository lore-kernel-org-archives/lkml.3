Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbbABSsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:48:17 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54764 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbbABSsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:48:15 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, matthias.bgg@gmail.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] ARM: mediatek: Enable uart for mt6589
Date: Fri,  2 Jan 2015 19:48:03 +0100
Message-Id: <1420224485-11043-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds uart ports for the mt6589 SoC from Mediatek.
It also enables the uart port for the mt6589 based Aquaris5 mobile phone.

This series is based on 3.19-rc1 and assumes that sysirq patch from Yingjoe Chen is added to the SoC [0].

[0] https://lkml.org/lkml/2014/11/25/132

Matthias Brugger (2):
  ARM: mediatek: dts: Add uart to mt6589
  ARM: mediatek: dts: Add uart to Aquaris5

 arch/arm/boot/dts/mt6589-aquaris5.dts |  8 +++++++-
 arch/arm/boot/dts/mt6589.dtsi         | 38 +++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

-- 
1.9.1

