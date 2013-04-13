Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3DMBkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:40:52 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39354 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3DMBku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:40:50 -0400
MIME-Version: 1.0
X-Originating-IP: [114.40.29.122]
In-Reply-To: <2583577.Kz0O4QXtvD@vostro.rjw.lan>
References: <1365746058.4025.1.camel@phoenix>
	<1413655.hhUbBAKNUi@vostro.rjw.lan>
	<002101ce3776$cbc83f90$6358beb0$@samsung.com>
	<2583577.Kz0O4QXtvD@vostro.rjw.lan>
Date: Sat, 13 Apr 2013 09:40:49 +0800
Message-ID: <CAFRkauAD9H_euMUWqw2mgHDFT-B+gfHP5_tz+2LoOz5t_BPn7Q@mail.gmail.com>
Subject: Re: [RESEND][PATCH 1/3] PM / devfreq: exynos4_bus: Fix missing
 mutex_unlock if opp_find_freq_floor fails
From: Axel Lin <axel.lin@ingics.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "myungjoo.ham" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/13 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday, April 12, 2013 09:11:00 PM myungjoo.ham wrote:
>> > On Friday, April 12, 2013 11:52:01 AM 함명주 wrote:
>> > > > On Friday, April 12, 2013 01:54:18 PM Axel Lin wrote:
>> > > > > We need to call mutex_unlock() in the error path.
>> > > > >
>> > > > > Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> > > >
>> > > > All three patches applied to linux-pm.git/linux-next.
>> > > >
>> > > > Exynos maintainers, if you have any objections, please holler.
>> > > >
>> > > > Thanks,
>> > > > Rafael
>> > >
>> > > This patch was included in the last pull-request patchset
>> > > though the path was updated. (its precedessor patch moved
>> > > exynos drivers to /drivers/devfreq/exynos/* after adding
>> > > Exynos common driver files)
>> >
>> > OK, so do you want me to drop it?
>> >
>> > What about the remaining two?
>>
>> Yes, please drop 1/3. It's duplicated.
>>
>> The patches 2~3/3 can wait. They are actually not bugfixes.
>
> OK, I've dropped all three.
>
> Axel, please push [2-3/3] thorugh the Exynos tree.

I thought I already Cc all devfreq maintainers.
Is there any other thing I need to do?

Regards,
Axel
