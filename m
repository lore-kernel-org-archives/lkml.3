Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaEYUJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 16:09:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63893 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaEYUJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 16:09:39 -0400
Message-ID: <53824DFA.3020407@samsung.com>
Date: Mon, 26 May 2014 05:09:30 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Tarek Dakhran <t.dakhran@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Heiko Stuebner <heiko@sntech.de>,
        linux-doc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Romain Naour <romain.naour@openwide.fr>,
        Tarek Dakhran <t.dakhran@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v10 3/3] ARM: dts: Add initial device tree support for
 EXYNOS5410
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com> <1400841343-6016-4-git-send-email-t.dakhran@samsung.com> <537FBA7A.3000605@gmail.com>
In-Reply-To: <537FBA7A.3000605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/14 06:15, Tomasz Figa wrote:
> Hi Tarek,
>
> On 23.05.2014 12:35, Tarek Dakhran wrote:
>> Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.
>>
>> Signed-off-by: Tarek Dakhran<t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov<v.tyrtov@samsung.com>
>> ---
>>   arch/arm/boot/dts/Makefile                |    1 +
>>   arch/arm/boot/dts/exynos5410-smdk5410.dts |   82 ++++++++++++
>>   arch/arm/boot/dts/exynos5410.dtsi         |  206 +++++++++++++++++++++++++++++
>>   3 files changed, 289 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>>   create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
>
> Looks good. Hopefully we can have this patch applied soon, so it won't
> get outdated again.
>
Yes.

Tarek, please respin as soon as possible.

> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>

- Kukjin
