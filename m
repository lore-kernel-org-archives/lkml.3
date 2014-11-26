Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaKZNs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:48:56 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42676 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbaKZNsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:48:55 -0500
Message-ID: <5475DA1C.50307@st.com>
Date: Wed, 26 Nov 2014 14:48:12 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        arnd Bergmann <arnd@arndb.de>, olof Johansson <olof@lixom.net>
Cc: <lee.jones@linaro.org>
Subject: Re: [PATCH] MAINTAINERS: Add ahci_st.c to ARCH/STI architecture
References: <1416386694-7402-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1416386694-7402-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-26_04:2014-11-26,2014-11-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 11/19/2014 09:44 AM, Peter Griffin wrote:
> This patch adds the ahci_st.c driver found on STMicroelectronics
> stih41x consumer electronics SoC's into the STI arch section
> of the maintainers file.
>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Arnd, Olof, could you pick this one directly?
I only have this single patch remaining for v3.19, so didn't planned to 
send another pull-request.

Thanks,
Maxime

