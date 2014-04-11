Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaDKWas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:30:48 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33658 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaDKWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <5347AD19.7080905@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
	<1397124377-16969-4-git-send-email-cw00.choi@samsung.com>
	<20140411040050.GD14934@quad.lixom.net>
	<53477347.1080603@samsung.com>
	<5347AD19.7080905@samsung.com>
Date: Sat, 12 Apr 2014 07:30:46 +0900
Message-ID: <CAGTfZH2DEWjLi=d0_U0mHYACY+_EUTt4Y3GyOvzVYb7HQk62mA@mail.gmail.com>
Subject: Re: [PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent
 connected with GIC
From: =?UTF-8?B?7LWc7LCs7Jqw?= <cwchoi00@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel <linux-kernel@vger.kernel.org>, yj44.cho@samsung.com,
        inki.dae@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Fri, Apr 11, 2014 at 5:51 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Chanwoo,
>
>
> On 11.04.2014 06:44, Chanwoo Choi wrote:
>>
>> Hi,
>>
>> On 04/11/2014 01:00 PM, Olof Johansson wrote:
>>>
>>> On Thu, Apr 10, 2014 at 07:06:02PM +0900, Chanwoo Choi wrote:
>>>>
>>>> This patch add interrupt-parent node to connected with GIC.
>>>> All interrupt-related dt nodes need default interrupt-parent node.
>>>>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>
>>>
>>> There's no point in splitting these off in separate patches; fold them
>>> into one patch that introduces the SoC dtsi, please.
>>
>>
>> OK, I will consolidate following two patches into one patch.
>>
>> [PATCH 11/27] ARM: dts: exynos3250: Add GIC dt node for Exynos3250
>> [PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent connected
>> with GIC
>>
>
> I believe the intention was to squash all the patches related to
> exynos3250.dtsi into a single patch called "ARM: dts: Add device tree
> sources for Exynos3250". To retain authorship information, signed-off-by
> tags should be merged from all those patches too.
>

As you comment, I will consolidate exynos3250.dtsi into only one patch
on next posting(v2).
Thanks,

Best Regards,
Chanwoo Choi
