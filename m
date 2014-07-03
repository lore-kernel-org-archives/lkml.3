Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaGCHXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:23:39 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35082 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755535AbaGCHXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:23:37 -0400
Message-ID: <53B504CA.9060502@st.com>
Date: Thu, 3 Jul 2014 09:22:50 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <p.zabel@pengutronix.de>, <srinivas.kandagatla@gmail.com>,
        <patrice.chotard@st.com>
Cc: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Add reset controllers for STiH407 SoC
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-03_03:2014-07-02,2014-07-03,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

	The series look good to me.

Thanks,
Maxime

On 07/02/2014 04:08 PM, Peter Griffin wrote:
> This series adds reset controller support for the STiH407 SoC.
>
> Changes since v1
>   - Update copyright to 2014
>   - Add const qualifier
>   - Fix various whitespace issues
>   - Remove THIS_OWNER
>   - Move DT documentation into separate patch
>
> Peter Griffin (4):
>    reset: stih407: Add softreset, powerdown and picophy controllers
>    reset: sti: Document sti-picophyreset controllers bindings.
>    ARM: sti: Add STiH407 Kconfig entry to select STIH407_RESET
>    ARM: sti: Add STiH407 reset controller support.
>
>   .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
>   arch/arm/boot/dts/stih407.dtsi                     |  16 +++
>   arch/arm/mach-sti/Kconfig                          |  10 ++
>   drivers/reset/sti/Kconfig                          |   4 +
>   drivers/reset/sti/Makefile                         |   1 +
>   drivers/reset/sti/reset-stih407.c                  | 158 +++++++++++++++++++++
>   .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
>   7 files changed, 292 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
>   create mode 100644 drivers/reset/sti/reset-stih407.c
>   create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h
>
