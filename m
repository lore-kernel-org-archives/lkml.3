Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaGUJt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:49:56 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51589 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbaGUJty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:49:54 -0400
Message-ID: <53CCE223.7080100@st.com>
Date: Mon, 21 Jul 2014 11:49:23 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ulf.hansson@linaro.org>, <chris@printf.net>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>
Cc: <lee.jones@linaro.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v4 09/10] ARM: update multi_v7_defconfig for STI
References: <1404918461-25390-1-git-send-email-peter.griffin@linaro.org> <1404918461-25390-10-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1404918461-25390-10-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-20_03:2014-07-18,2014-07-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/09/2014 05:07 PM, Peter Griffin wrote:
> This patch enables SDHCI STI platform driver.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>   arch/arm/configs/multi_v7_defconfig | 1 +
>   1 file changed, 1 insertion(+)
>
Added to my queue for v3.17.

Thanks,
Maxime
