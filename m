Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbbAVOlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:41:06 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51275 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbbAVOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:41:04 -0500
Message-ID: <54C10BDE.9090702@st.com>
Date: Thu, 22 Jan 2015 15:40:30 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: sti: Provide DT nodes for SBC SSC[0..2]
References: <1421921237-8991-1-git-send-email-lee.jones@linaro.org> <1421921237-8991-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1421921237-8991-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-22_05:2015-01-22,2015-01-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/22/2015 11:07 AM, Lee Jones wrote:
> The Synchronous Serial Controller is used to provide SPI.
>
> These are the ports which are located on the Stand-By Controller (SBC).
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/stih407-family.dtsi | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
>
>
Applied,

Thanks
