Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaI2JOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:14:25 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:50373 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaI2JOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:14:23 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 0/4] ARM: DT: apq8064 DT patches.
Date: Mon, 29 Sep 2014 10:14:04 +0100
Message-Id: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches adds dt nodes for RPM, USB and SATA IPs found in APQ8064.
All the driver support for these IPs are already available in v3.17, except
the RPM driver which is now accepted by Lee and Mark.

These patches depend on the header file from 
http://www.spinics.net/lists/arm-kernel/msg364310.html
for regulators.

Now that the RPM patch is accepted, should RPM patch go via arm-soc tree?
so that we can get more functionality on IFC6410 board in v3.18 mainline.

All these patches are tested on IFC6410 board.
Am hoping to get these patches for v3.18, as these patches were sitting in
my dev tree since last 3 merge windows.

Thanks,
srini

Srinivas Kandagatla (4):
  ARM: DT: apq8064: add rpm support
  ARM: DT: apq8064: Add usb host support.
  ARM: DT: apq8064: Add USB OTG support
  ARM: DT: apq8064: Add SATA controller support.

 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |  30 +++++
 arch/arm/boot/dts/qcom-apq8064.dtsi        | 190 +++++++++++++++++++++++++++++
 2 files changed, 220 insertions(+)

-- 
1.9.1

