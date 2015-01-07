Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbbAGHJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:09:47 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62124 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbbAGHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:09:46 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@linaro.org
Cc: linux@arm.linux.org.uk, kernel@pengutronix.de, stefan@agner.ch,
        jingchang.lu@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 0/2] Add SNVS clock gating and SNVS node for DT
Date: Wed,  7 Jan 2015 12:39:28 +0530
Message-Id: <cover.1420612799.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch set adds support for clock gating
of the SNVS peripheral required on the Vybrid platform.
Also adds a device tree node for this peripheral.

This patchset was send before along with the patch which
had clock changes to the rtc-snvs driver. Since these could
not be merged then, till the changes for rtc-snvs landed in
the mainline, I am sending them anew as the changes are now
in the for-next branch
https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/log/?h=for-next

The initial discussion can be found at the below links for the
earlier set of patches:

[RESEND] v2:
https://lkml.org/lkml/2014/12/3/23

v2:
https://lkml.org/lkml/2014/11/7/295

v1:
https://lkml.org/lkml/2014/9/26/492

Sanchayan Maity (2):
  ARM: imx: clk-vf610: Add clock for SNVS
  ARM: dts: vfxxx: Add SNVS node

 arch/arm/boot/dts/vf500.dtsi            |    4 ++++
 arch/arm/boot/dts/vfxxx.dtsi            |   14 ++++++++++++++
 arch/arm/mach-imx/clk-vf610.c           |    2 ++
 include/dt-bindings/clock/vf610-clock.h |    3 ++-
 4 files changed, 22 insertions(+), 1 deletion(-)

-- 
1.7.9.5

