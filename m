Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaEUL0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:26:32 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:33359 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbaEUL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:26:30 -0400
Message-ID: <537C8D4E.3000405@st.com>
Date: Wed, 21 May 2014 13:26:06 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <patrice.chotard@st.com>
Cc: <kernel@stlinux.com>
Subject: Re: [PATCH v2 2/3] ARM: sti: stih416: Enable board LED support for
 B2020 RevE
References: <1400661924-10745-1-git-send-email-lee.jones@linaro.org> <1400661924-10745-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1400661924-10745-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-21_04:2014-05-21,2014-05-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/21/2014 10:45 AM, Lee Jones wrote:
> There are two LEDs available on the B2020 RevE board, one red, one
> green.  In this patch we enable the red one for "heartbeat" and turn
> the green one off.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/stih416-b2020-revE.dts | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime


[...]
