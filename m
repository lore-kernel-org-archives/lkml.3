Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaE3SIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:08:23 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49849 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbaE3SIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:08:20 -0400
Message-ID: <5388C90B.605@samsung.com>
Date: Sat, 31 May 2014 03:08:11 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, ben-linux@fluff.org,
        linux@arm.linux.org.uk, l.krishna@samsung.com,
        chanho61.park@samsung.com, kyungmin.park@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add pmu sysreg node to Exynos3250
References: <1401085776-14212-1-git-send-email-cw00.choi@samsung.com> <538870F8.9090507@gmail.com>
In-Reply-To: <538870F8.9090507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/14 20:52, Tomasz Figa wrote:
> On 26.05.2014 08:29, Chanwoo Choi wrote:
>> This patch add pmusysreg node for Exynos3250 to access PMU (Power Management Unit)
>> register in a centralized way using syscon driver.
>>
>> Signed-off-by: Chanwoo Choi<cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
>>   arch/arm/boot/dts/exynos3250.dtsi                     | 5 +++++
>>   2 files changed, 6 insertions(+)
>
> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>
Applied, thanks.

- Kukjin
