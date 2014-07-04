Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbaGDLml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:42:41 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44911 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbaGDLmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:42:39 -0400
Message-ID: <53B6930F.50307@st.com>
Date: Fri, 4 Jul 2014 13:42:07 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <p.zabel@pengutronix.de>, <srinivas.kandagatla@gmail.com>,
        <patrice.chotard@st.com>
Cc: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] ARM: sti: Add STiH407 Kconfig entry to select
 STIH407_RESET
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org> <1404310129-14667-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1404310129-14667-4-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-04_03:2014-07-04,2014-07-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 07/02/2014 04:08 PM, Peter Griffin wrote:
> The STiH407 is a STMicroelectronics Digital Consumer electronics
> family, targetted at set-top-box and other audio/video applications.
>
> This patch selects the reset controller driver for this family which
> is essential to take various IP's on the SoC out of powerdown / reset.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>

Applied.

Thanks!
Maxime

