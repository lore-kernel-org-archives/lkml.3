Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaGUJel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:34:41 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:50155 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991AbaGUJej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:34:39 -0400
Message-ID: <53CCDE76.8060508@st.com>
Date: Mon, 21 Jul 2014 11:33:42 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <ajitpal.singh@st.com>, <edubezval@gmail.com>,
        <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <patrice.chotard@st.com>
Subject: Re: [PATCH 5/6] ARM: STi: DT: STiH416: Supply Thermal Controller
 Device Tree nodes
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org> <1401980819-19962-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1401980819-19962-6-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-20_03:2014-07-18,2014-07-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 06/05/2014 05:06 PM, Lee Jones wrote:
> We supply two of these.  The first is controlled by the System Configuration
> registers and the second one provided is a more traditional 'memory mapped'
> variant.  Each are handled by they own sub-driver.
>
> Signed-off-by: Ajit Pal Singh <ajitpal.singh@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/stih416.dtsi | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>

Added to my queue for v3.17.

Thanks,
Maxime
