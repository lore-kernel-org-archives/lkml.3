Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaKDNHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:07:37 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:42424 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaKDNHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:07:24 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de
Cc: linus.walleij@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 0/3] ARM: dts: vf610: USB/GPIO fixes
Date: Tue,  4 Nov 2014 14:07:07 +0100
Message-Id: <1415106430-6271-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

This patchset collects some vf610 device tree fixes. The first patch
was part of the "vf610: Add GPIO support" patchset. GPIO support is
merged by know, so I rebased that on top of your for-next branch.

The second patch is a USB fix I uncovered while testing the 3rd patch,
which adds regulators, mainly for proper USB VBUS support, as we have
them on our carrier boards.

Stefan Agner (3):
  ARM: dts: vf610: use new GPIO support
  ARM: dts: vf610: enable USB misc/phy nodes where necessary
  ARM: dts: vf-colibri: add USB regulators

 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi | 45 ++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/vf-colibri.dtsi         | 37 +++++++++++++++++++++++++
 arch/arm/boot/dts/vf610-twr.dts           |  9 +++++++
 arch/arm/boot/dts/vfxxx.dtsi              |  1 +
 4 files changed, 91 insertions(+), 1 deletion(-)

-- 
2.1.3

