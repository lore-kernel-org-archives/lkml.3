Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3GYVAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:00:50 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:65477 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3GYVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:00:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <000401ce88d4$33773de0$9a65b9a0$@samsung.com>
References: <1374680547-5336-1-git-send-email-olof@lixom.net>
	<000401ce88d4$33773de0$9a65b9a0$@samsung.com>
Date: Thu, 25 Jul 2013 14:00:47 -0700
Message-ID: <CAOesGMh5-aRR+eZVimNnZJ++f74tbURWOeri-46GNQfK_r3JuA@mail.gmail.com>
Subject: Re: [PATCH] mfd: max8925: fix dt code for backlight
From: Olof Johansson <olof@lixom.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Qing Xu <qingx@marvell.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 6:13 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Thursday, July 25, 2013 12:42 AM, Olof Johansson wrote:
>>
>> The device-tree enablement for max8925 has several problems, but besides
>> the bindings being wrong (and not having seen review) there's also some
>> bad coding practices on how to fill in the platform_data from device tree.
>>
>> I came across this since it causes a warning when compiling
>> mmp2_defconfig, and instead of doing the minimal fix to silence the
>> warning, I restructured the code a bit.
>>
>> This silences the warning:
>> drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
>> drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]
>>
>> Note that the bindings themselves need to be revisited too, but that will
>> affect more than just the backlight driver and is best done separately;
>> this just fixes the bad code for the backlight driver.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>
>> Richard, Jingoo, this would be good to see go into 3.11 if you're
>> comfortable with it.
>
> CC'ed Andrew Morton
>
>
> Hi Olof Johansson,
>
> Currently, there is not git tree for Backlight subsystem.
> I hope that this would go into 3.11 through one of other trees
> with my Ack.
>
> If not, it will go into 3.12-rc1 through mm-tree.
>
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Ok, if you don't mind I can take it through arm-soc for 3.11 with your ack then.

Thanks!

-Olof
