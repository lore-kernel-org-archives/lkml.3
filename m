Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaGUJsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:48:53 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:49739 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbaGUJsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:48:52 -0400
Message-ID: <53CCE1DB.5090607@st.com>
Date: Mon, 21 Jul 2014 11:48:11 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@nvidia.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Lee Jones <lee.jones@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>, <kernel@stlinux.com>
Subject: Re: [STLinux Kernel] [RESEND PATCH] ARM: multi_v7_defconfig: add
 ST Keyscan driver
References: <1403876061-8519-1-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1403876061-8519-1-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-20_03:2014-07-18,2014-07-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/27/2014 03:34 PM, Gabriel FERNANDEZ wrote:
> This patch adds KEYBOARD_ST_KEYSCAN config
>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/configs/multi_v7_defconfig | 1 +
>   1 file changed, 1 insertion(+)
>

Added to my queue for v3.17.

Thanks,
Maxime
