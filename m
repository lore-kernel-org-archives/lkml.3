Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaIWHoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:44:25 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54034 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaIWHoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:44:23 -0400
Message-ID: <5421249E.2000700@st.com>
Date: Tue, 23 Sep 2014 09:43:26 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <olof@lixom.net>
Cc: <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [RESEND PATCH 0/4] Enables STMicroelectronics Flexgen Clock support
References: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_03:2014-09-23,2014-09-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabi,

	Series applied to sti-dt-for-v3.18.

Thanks!
Maxime

On 08/25/2014 04:44 PM, Gabriel FERNANDEZ wrote:
> These patches enables clock drivers for STih407 boards.
>
> Gabriel Fernandez (4):
>    ARM: STi: DT: STiH407: 407 DT Entry for clockgen A0
>    ARM: STi: DT: STiH407: 407 DT Entry for clockgen C0
>    ARM: STi: DT: STiH407: 407 DT Entry for clockgen D0/D2/D3
>    ARM: STi: DT: STiH407: 407 DT Entry for clockgenA9
>
>   arch/arm/boot/dts/stih407-clock.dtsi     | 295 ++++++++++++++++++++++++++++++-
>   arch/arm/boot/dts/stih407.dtsi           |  18 +-
>   include/dt-bindings/clock/stih407-clks.h |  11 ++
>   3 files changed, 307 insertions(+), 17 deletions(-)
>   create mode 100644 include/dt-bindings/clock/stih407-clks.h
>
