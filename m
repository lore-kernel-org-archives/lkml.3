Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaEVPqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:46:35 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56400 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbaEVPqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:46:33 -0400
Message-ID: <537E1BB9.4070505@st.com>
Date: Thu, 22 May 2014 17:46:01 +0200
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
Subject: Re: [PATCH 2/8] mmc: sdhci-st: STMicroelectronics SDHCI binding documentation.
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org> <1400771902-26553-3-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1400771902-26553-3-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-22_03:2014-05-22,2014-05-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/22/2014 05:18 PM, Peter Griffin wrote:
> This patch adds the device tree binding documentation for ST
> SDHCI driver. It contains the differences between the core properties
> in mmc.txt and the properties used by the sdhci-st driver.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>   Documentation/devicetree/bindings/mmc/sdhci-st.txt | 26 ++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-st.txt
>

You can add my:
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

[...]
