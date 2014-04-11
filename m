Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbaDKNXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:23:20 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52763 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410AbaDKNUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:20:24 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: linux-kernel@vger.kernel.org, patrice.chotard@st.com,
        maxime.coquelin@st.com
Cc: kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        mturquette@linaro.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 0/9] ARM: STi: Add Clock driver support STiH415 & STiH416
Date: Fri, 11 Apr 2014 15:19:47 +0200
Message-Id: <1397222396-30106-1-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_04:2014-04-11,2014-04-11,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this series is to add DT definition for STiH415 
and STiH416 SoCs on B2000 and B2020 boards.

Gabriel Fernandez (9):
  ARM: STi: DT: STiH416: 416 DT Entry for clockgen A0/1/10/11/12
  ARM: STi: DT: STiH416: Remove unused CLK_S_ICN_REG_0 fixed clock
  ARM: STi: DT: STiH416: Remove unused CLK_S_GMAC0_PHY & CLK_S_ETH1_PHY
    fixed clocks
  ARM: STi: DT: STiH416: 416 DT Entry for clockgen B/C/D/E/F
  ARM: STi: DT: STiH416: 416 DT Entry for clockgen A9/DDR/GPU
  ARM: STi: DT: STiH415: 415 DT Entry for clockgen A0/1/10/11/12
  ARM: STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock
  ARM: STi: DT: STiH415: Remove unused CLK_S_GMAC0_PHY & CLK_S_ETH1_PHY
    fixed clocks
  ARM: STi: DT: STiH415: 415 DT Entry for clockgen A9

 arch/arm/boot/dts/stih415-clks.h     |  15 +
 arch/arm/boot/dts/stih415-clock.dtsi | 517 ++++++++++++++++++++++++-
 arch/arm/boot/dts/stih415.dtsi       |  10 +-
 arch/arm/boot/dts/stih416-clks.h     |  15 +
 arch/arm/boot/dts/stih416-clock.dtsi | 732 ++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/stih416.dtsi       |  10 +-
 6 files changed, 1256 insertions(+), 43 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih415-clks.h
 create mode 100644 arch/arm/boot/dts/stih416-clks.h

-- 
1.9.1

