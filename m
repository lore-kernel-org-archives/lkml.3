Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaFEHwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:52:10 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42538 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbaFEHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:52:08 -0400
Message-ID: <5390216D.9020306@st.com>
Date: Thu, 5 Jun 2014 09:51:09 +0200
From: Gabriel Fernandez <gabriel.fernandez@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>
Cc: <mturquette@linaro.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <kernel@stlinux.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [STLinux Kernel] [PATCH RESEND 06/12] drivers: clk: st: Add polarity
 bit indication
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org> <1401892320-18211-7-git-send-email-gabriel.fernandez@linaro.org> <20140605074516.GA3865@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20140605074516.GA3865@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.19.41]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-05_02:2014-06-04,2014-06-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/05/2014 09:45 AM, Peter Griffin wrote:
> Hi Gabi,
>
> On Wed, 04 Jun 2014, Gabriel FERNANDEZ wrote:
>
>> This patch introduces polarity indication for pll power up bit
>> and for standby bit in order to have same code between Orly 2
>> and CAN.
> I think it would be better to refer to the SoC's by there numeric
> name stih416 and stih407, as people unfamiliar with ST SoC names
> reading the commit message are unlikely to know what Orly2 or CAN
> mean.
>
> Once fixed you can add my:
> Acked-by: Peter Griffin <peter.griffin@linaro.org>

Ok thanks Peter

> regards,
>
> Peter.
>

