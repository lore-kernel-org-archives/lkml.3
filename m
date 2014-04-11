Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaDKWjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:39:14 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36076 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaDKWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:39:11 -0400
MIME-Version: 1.0
In-Reply-To: <5435579.0l6Y80MnUs@wuerfel>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
	<20140411014858.GC14934@quad.lixom.net>
	<53474D66.7020605@samsung.com>
	<5435579.0l6Y80MnUs@wuerfel>
Date: Sat, 12 Apr 2014 07:39:10 +0900
Message-ID: <CAGTfZH0s53B+C1EVeOsX_zhkcddJFOwGEAaWPF8UxFSpwvoqFQ@mail.gmail.com>
Subject: Re: [PATCH 03/27] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
From: =?UTF-8?B?7LWc7LCs7Jqw?= <cwchoi00@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, hyunhee.kim@samsung.com,
        sw0312.kim@samsung.com, linux-kernel <linux-kernel@vger.kernel.org>,
        yj44.cho@samsung.com, inki.dae@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Apr 11, 2014 at 5:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 11 April 2014 11:03:18 Chanwoo Choi wrote:
>> On 04/11/2014 10:48 AM, Olof Johansson wrote:
>> > On Thu, Apr 10, 2014 at 06:37:14PM +0900, Chanwoo Choi wrote:
>> >> This patch add memory mapping for PMU (Power Management Unit) which is used
>> >> for power control of Exynos3250.
>> >>
>> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> >
>> > Signed-off-by is in the wrong order, if Kyungmin wrote the patch and you're
>> > just posting it...
>>
>>
>> No, I implemented this patch and posted it.
>
> What did Kyungmin do then? If you submitted the patch to him, and he
> sent it back to you, you should be listed twice, although you could
> just as easily leave him out.
>

Sorry, It has happen a confusion due to my mistake.

As I reply on other patch as Olof comment, I'll use 'Acked-by' instead
of  'Signed-off' for Kyungmin Park.
- [PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent
connected with GIC

Thanks,

Best Regards,
Chanwoo Choi
