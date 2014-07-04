Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbaGDDpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:45:45 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61000 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaGDDpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <014701cf9719$f4bac090$de3041b0$@samsung.com>
References: <cover.1404425176.git.joe@perches.com>
	<169fb51c0d59b216636d48810792f67ecfb5179d.1404425176.git.joe@perches.com>
	<014701cf9719$f4bac090$de3041b0$@samsung.com>
Date: Fri, 4 Jul 2014 09:15:42 +0530
Message-ID: <CAK5sBcHPE8wqyu2UVouzCMJen+h7Ta+WBmo+wnPqvtGk0nq79g@mail.gmail.com>
Subject: Re: [PATCH 09/16] MAINTAINERS: Update Samsunt MFD drivers pattern
From: Sachin Kamat <spk.linux@gmail.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 5:23 AM, Sangbeom Kim <sbkim73@samsung.com> wrote:
> On Friday, July 04, 2014 7:08 AM, Joe Perches wrote:
>
>>  F:   drivers/regulator/s2m*.c
>>  F:   drivers/regulator/s5m*.c
>> -F:   drivers/rtc/rtc-sec.c
>>  F:   include/linux/mfd/samsung/
>>
>
> Yes, You are right.
> There is no rtc-sec.c
> Instead, rtc-s5m.c was upstreamed.
> I will post update patch.

Joe,

In any case, if this patch is going to be appled, please fix typo in subject

s/Samsunt/Samsung

-- 
Regards,
Sachin.
