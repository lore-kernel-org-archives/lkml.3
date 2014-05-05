Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaEEPlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:41:01 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60920 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbaEEPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:40:56 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 0/4] Enable ST Keyscan driver
Date: Mon,  5 May 2014 17:38:36 +0200
Message-Id: <1399304320-18197-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-05_02:2014-05-05,2014-05-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this series is to enable ST Keyscan support to ST SoCs.
The DT definition is added for STiH415 and STiH416 SoCs on
B2000 board.
Tested on B2000 sti board.

Gabriel Fernandez (4):
  ARM: STi: DT: add keyscan for stih415
  ARM: STi: DT: add keyscan for stih416
  ARM: STi: DT: add keyscan for stih41x-b2000
  ARM: multi_v7_defconfig: add ST Keyscan driver

 arch/arm/boot/dts/stih415-pinctrl.dtsi | 16 ++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi         | 12 ++++++++++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi | 16 ++++++++++++++++
 arch/arm/boot/dts/stih416.dtsi         | 12 ++++++++++++
 arch/arm/boot/dts/stih41x-b2000.dtsi   | 23 +++++++++++++++++++++++
 arch/arm/configs/multi_v7_defconfig    |  1 +
 6 files changed, 80 insertions(+)

-- 
1.9.1

