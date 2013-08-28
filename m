Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3H1AMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 20:12:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53879 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3H1AMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 20:12:48 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v3 0/2] Document msm_serial bindings and support newer uartdms
Date: Tue, 27 Aug 2013 17:12:42 -0700
Message-Id: <1377648764-23453-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset aligns the msm_serial driver more with downstream usage and
updates the driver's DT bindings.

Changes since v2:
 * Fixed up DT review comments
 * Dropped patches that were picked up in tty tree

Changes since v1:
 * Dropped _clk postfix from {core,iface}_clk
 * Split DT binding into two files
 * Renamed DT binding files to match compatible strings
 * Fixed up DT review comments
 * Added new patch 5/5 (more than 1 char for UARTDM)

Stephen Boyd (2):
  devicetree: serial: Document msm_serial bindings
  ARM: dts: msm: Update uartdm compatible strings

 .../devicetree/bindings/tty/serial/msm_serial.txt  | 27 -----------
 .../bindings/tty/serial/qcom,msm-uart.txt          | 25 ++++++++++
 .../bindings/tty/serial/qcom,msm-uartdm.txt        | 53 ++++++++++++++++++++++
 arch/arm/boot/dts/msm8660-surf.dts                 |  2 +-
 arch/arm/boot/dts/msm8960-cdp.dts                  |  2 +-
 5 files changed, 80 insertions(+), 29 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt
 create mode 100644 Documentation/devicetree/bindings/tty/serial/qcom,msm-uart.txt
 create mode 100644 Documentation/devicetree/bindings/tty/serial/qcom,msm-uartdm.txt

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

