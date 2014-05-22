Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaEVPoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:44:54 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47212 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbaEVPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:44:52 -0400
Message-ID: <537E1B55.1090807@st.com>
Date: Thu, 22 May 2014 17:44:21 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <chris@printf.net>, <ulf.hansson@linaro.org>
Cc: <kernel@stlinux.com>, <lee.jones@linaro.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: Add SDHCI support for STMicroelectronics SoCs
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-22_03:2014-05-22,2014-05-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 05/22/2014 05:18 PM, Peter Griffin wrote:
> This series adds a SDHCI platform driver for ST SoCs, along with
> the additional device tree bindings and configuration to enable
> the controller to work properly.
>
> Initially it supports the stih416 and stih415 SoCs, and has
> been tested on a stih416-b2020 board.

In next version, could you also add  drivers/mmc/host/sdhci-st.c in the 
ARM/STI ARCHITECTURE field of MAINTAINERS file?


Thanks,
Maxime


>
> regards,
>
> Peter.
>
