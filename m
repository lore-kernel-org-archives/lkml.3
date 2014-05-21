Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaEUL03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:26:29 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42592 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbaEUL00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:26:26 -0400
Message-ID: <537C8D41.7090403@st.com>
Date: Wed, 21 May 2014 13:25:53 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <patrice.chotard@st.com>
Cc: <kernel@stlinux.com>
Subject: Re: [PATCH v2 1/3] ARM: sti: stih416: Add support for B2020 RevE
References: <1400661924-10745-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1400661924-10745-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-21_04:2014-05-21,2014-05-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/21/2014 10:45 AM, Lee Jones wrote:
> The B2020 RevE differs from the other B2020 boards in a few subtle ways;
> including the Ethernet reset GPIO which this patch adds support for and
> the LED wiring which will follow in a latter patch.  Without supplying
> these differences Ethernet and the board LEDs simply will not work.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/Makefile               |  3 ++-
>   arch/arm/boot/dts/stih416-b2020-revE.dts | 21 +++++++++++++++++++++
>   2 files changed, 23 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm/boot/dts/stih416-b2020-revE.dts
>


Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime


[...]
