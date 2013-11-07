Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3KGLwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:52:03 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53213 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3KGLwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:52:01 -0500
MIME-Version: 1.0
In-Reply-To: <4908982.5yt51ejnyk@amdc1227>
References: <CAK9yfHz+H4FQpo_J0ycJP_rvRPMyDgXpZFvx+GvRjyywECUoCw@mail.gmail.com>
	<4908982.5yt51ejnyk@amdc1227>
Date: Thu, 7 Nov 2013 17:22:00 +0530
Message-ID: <CAK9yfHz-ZhR-k59SDmoUO8L57XjBp24A25AMKzXbpkNzLDpQEQ@mail.gmail.com>
Subject: Re: Boot failure on Origen with next-20131107
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 7 November 2013 16:59, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Sachin,
>
> On Thursday 07 of November 2013 16:25:15 Sachin Kamat wrote:
>> Hi,
>>
>> Today's linux next fails to boot Origen (Exynos4210) board. However,
>> Arndale (Exynos5250) board boots fine. Git bisect points to the
>> following as bad commit:
>>
>> 2361613206e66ce59cc0e08efa8d98ec15b84ed1 is the first bad commit
>> commit 2361613206e66ce59cc0e08efa8d98ec15b84ed1
>> Author: Grant Likely <grant.likely@linaro.org>
>> Date:   Sun Sep 15 22:32:39 2013 +0100
>>
>>     of/irq: Refactor interrupt-map parsing
>>
>> Reverting gave several conflicts which I could not resolve with certainty.
>
> This issue has been already fixed, but the fix has not yet been merged.
>
> See: https://lkml.org/lkml/2013/11/5/255

Thanks for the pointer. With your patch I am able to boot Origen using
the latest next tree.
I have replied to your patch with my tested-by.

-- 
With warm regards,
Sachin
