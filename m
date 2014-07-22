Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaGVJCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:02:51 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60438 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831AbaGVJCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:02:49 -0400
Message-ID: <53CE2894.2030109@st.com>
Date: Tue, 22 Jul 2014 11:02:12 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
Cc: <kernel@stlinux.com>
Subject: Re: [STLinux Kernel] [PATCH v3+1 5/5] ARM: DT: STi: STiH416: Add
 DT node for MiPHY365x
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>	<1404906074-31992-6-git-send-email-lee.jones@linaro.org> <20140711115406.GB2954@lee--X1>
In-Reply-To: <20140711115406.GB2954@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-22_03:2014-07-22,2014-07-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 07/11/2014 01:54 PM, Lee Jones wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>

Added to my queue for v3.17.

Thanks,
Maxime
