Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaKJL2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:28:44 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53940 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752531AbaKJL2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:28:41 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: arm@kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 0/2] arm64: Add support for Juno development board
Date: Mon, 10 Nov 2014 11:27:53 +0000
Message-Id: <1415618875-8469-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof, Arnd and Kevin,

I have sent these patches a week ago but I have not properly addressed
them to you, so you might have missed them. The original submission is
here: http://lkml.org/lkml/2014/10/31/372.

Changes vs v1: Dropped the defconfig change that is now in mainline.

Please consider this series for addition to the arm-soc tree.

This patchset adds device tree support for ARM's AArch64 Juno development
board. It enables use of various peripherals on the board, from USB and
networking to I2C and PL011 UART.

The patches can also be found in the repository at:

   git://github.com/ARM-software/linux.git juno/dts-for-armsoc

for you to fetch.

Best regards,
Liviu

Liviu Dudau (2):
  arm64: Create link to include/dt-bindings to enable C preprocessor use.
  arm64: Add Juno SoC device tree.

 arch/arm64/boot/dts/Makefile            |   2 +-
 arch/arm64/boot/dts/include/dt-bindings |   1 +
 arch/arm64/boot/dts/juno.dts            | 374 ++++++++++++++++++++++++++++++++
 3 files changed, 376 insertions(+), 1 deletion(-)
 create mode 120000 arch/arm64/boot/dts/include/dt-bindings
 create mode 100644 arch/arm64/boot/dts/juno.dts

-- 
2.1.3

