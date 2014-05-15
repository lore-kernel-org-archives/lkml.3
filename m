Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaEOODK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:03:10 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:49615 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbaEOODH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:03:07 -0400
Message-ID: <5374C8C6.8060202@st.com>
Date: Thu, 15 May 2014 16:01:42 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH v2 00/10] ARM: STi: Add Clock driver support STiH415 &
 STiH416
References: <1400073858-28912-1-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1400073858-28912-1-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-15_03:2014-05-15,2014-05-15,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabi,

	For the series:

	Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

	It will be part of DT pull request I'm preparing for v3.16.

Thanks,
Maxime

On 05/14/2014 03:24 PM, Gabriel FERNANDEZ wrote:
> Changes in v2:
>   - move stih415-clks.h & stih416-clks.h to include/dt-bindings/clock/
>   - add clk_ignore_unused to bootargs. Interconnect clocks are not yet
>     managed at the init, then we have to start the kernel with
>     clk_ignore_unused.
>
> The goal of this series is to add DT definition for STiH415
> and STiH416 SoCs on B2000 and B2020 boards.
>
> Gabriel Fernandez (10):
>    ARM: STi: DT: STiH416: 416 DT Entry for clockgen A0/1/10/11/12
>    ARM: STi: DT: STiH416: Remove unused CLK_S_ICN_REG_0 fixed clock
>    ARM: STi: DT: STiH416: Remove unused CLK_S_GMAC0_PHY & CLK_S_ETH1_PHY
>      fixed clocks
>    ARM: STi: DT: STiH416: 416 DT Entry for clockgen B/C/D/E/F
>    ARM: STi: DT: STiH416: 416 DT Entry for clockgen A9/DDR/GPU
>    ARM: STi: DT: STiH415: 415 DT Entry for clockgen A0/1/10/11/12
>    ARM: STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock
>    ARM: STi: DT: STiH415: Remove unused CLK_S_GMAC0_PHY & CLK_S_ETH1_PHY
>      fixed clocks
>    ARM: STi: DT: STiH415: 415 DT Entry for clockgen A9
>    ARM: STi: DT: STiH41x Add clk_ignore_unused to bootargs
>
>   arch/arm/boot/dts/stih415-clock.dtsi     | 517 +++++++++++++++++++++-
>   arch/arm/boot/dts/stih415.dtsi           |  10 +-
>   arch/arm/boot/dts/stih416-clock.dtsi     | 732 ++++++++++++++++++++++++++++++-
>   arch/arm/boot/dts/stih416.dtsi           |  10 +-
>   arch/arm/boot/dts/stih41x-b2000.dtsi     |   2 +-
>   arch/arm/boot/dts/stih41x-b2020.dtsi     |   2 +-
>   include/dt-bindings/clock/stih415-clks.h |  15 +
>   include/dt-bindings/clock/stih416-clks.h |  15 +
>   8 files changed, 1258 insertions(+), 45 deletions(-)
>   create mode 100644 include/dt-bindings/clock/stih415-clks.h
>   create mode 100644 include/dt-bindings/clock/stih416-clks.h
>
