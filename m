Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaEVPvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:51:24 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:50695 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbaEVPvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:51:21 -0400
Message-ID: <537E1CD9.5020900@st.com>
Date: Thu, 22 May 2014 17:50:49 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <chris@printf.net>, <ulf.hansson@linaro.org>
Cc: <kernel@stlinux.com>, <lee.jones@linaro.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 3/8] ARM: STi: DT: Add sdhci pins for stih416
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org> <1400771902-26553-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1400771902-26553-4-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-22_03:2014-05-22,2014-05-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/22/2014 05:18 PM, Peter Griffin wrote:
> This adds the required pin config for both SDHCI controllers on
> the stih416 SoC.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>   arch/arm/boot/dts/stih416-pinctrl.dtsi | 39 ++++++++++++++++++++++++++++++++++
>   1 file changed, 39 insertions(+)
>


For all the DT patches, once Lee's comments taken into account, you can 
add my:

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks!
Maxime
