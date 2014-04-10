Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965869AbaDJTR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:17:58 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:56869 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965784AbaDJTRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:17:54 -0400
Message-ID: <5346EE5A.3070408@gmail.com>
Date: Thu, 10 Apr 2014 21:17:46 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 08/27] pinctrl: exynos: Add driver data for Exynos3250
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>	<1397122124-15690-9-git-send-email-cw00.choi@samsung.com> <CACRpkdYiFCHFifkpRwDhdAGqBrGTU5E4mfdGE8u1c=zrim17aA@mail.gmail.com>
In-Reply-To: <CACRpkdYiFCHFifkpRwDhdAGqBrGTU5E4mfdGE8u1c=zrim17aA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10.04.2014 20:42, Linus Walleij wrote:
> On Thu, Apr 10, 2014 at 11:28 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> This patch adds driver data (bank list and EINT layout) for Exynos3250
>> to pinctrl-exynos driver. Exynos3250 includes 158 multi-functional input/output
>> ports. There are 23 general port groups.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Ugh can Tomasz send out his patches himself, I get confused...
> It was also sent two times, the second time with CC:s added.
> Tomasz, shall I merge this?

I'm fine with this patch being sent by Chanwoo, although he should have 
probably added his sign-off to the list, as the person sending it.

Chanwoo, can you make sure that there is your sign-off on all the 
patches from this series?

Best regards,
Tomasz
