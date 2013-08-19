Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3HSVkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:40:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34876 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3HSVkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:40:00 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH 0/4] Document msm_serial bindings and support newer uartdms
Date: Mon, 19 Aug 2013 14:39:53 -0700
Message-Id: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset aligns the msm_serial driver more with downstream usage and
also documents the msm_serial driver's DT binding. Along the way we
update the clock names and add support for future UARTDM hardware that
isn't part of a GSBI.

Stephen Boyd (4):
  msm_serial: Switch clock consumer strings and simplify code
  devicetree: serial: Document msm_serial bindings
  msm_serial: Add support for non-GSBI UARTDM devices
  ARM: dts: msm: Update uartdm compatible strings

 .../devicetree/bindings/serial/msm_serial.txt      | 82 ++++++++++++++++++++++
 arch/arm/boot/dts/msm8660-surf.dts                 |  2 +-
 arch/arm/boot/dts/msm8960-cdp.dts                  |  2 +-
 arch/arm/mach-msm/devices-msm7x00.c                |  6 +-
 arch/arm/mach-msm/devices-msm7x30.c                |  2 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |  6 +-
 drivers/tty/serial/msm_serial.c                    | 29 ++++----
 7 files changed, 104 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/msm_serial.txt

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

