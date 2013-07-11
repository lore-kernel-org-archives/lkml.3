Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab3GKXvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:51:44 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63694 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3GKXvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FDFF@SC-VEXCH4.marvell.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-3-git-send-email-zhangwm@marvell.com>
	<20130709181434.76f6216d@skate>
	<201307092316.20905.arnd@arndb.de>
	<CAN1soZyFztVR1XSw9bDS5JexK0Mdbpr6yevatVf+MnBohwCj1Q@mail.gmail.com>
	<175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FDFF@SC-VEXCH4.marvell.com>
Date: Fri, 12 Jul 2013 07:51:41 +0800
Message-ID: <CAN1soZzkycTDc-U4h43LC6hSYS1v+UkG+C4k-+dYMxRL=t7Zbg@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF DECLARE
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 7:23 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> Haojian,
>
>
>> -----Original Message-----
>> From: Haojian Zhuang [mailto:haojian.zhuang@gmail.com]
>> Sent: 2013年7月10日 13:59
>> To: Arnd Bergmann
>> Cc: Thomas Petazzoni; Neil Zhang; Grant Likely;
>> devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org;
>> linux-arm-kernel@lists.infradead.org
>> Subject: Re: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF
>> DECLARE
>>
>> On Wed, Jul 10, 2013 at 5:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Tuesday 09 July 2013, Thomas Petazzoni wrote:
>> >> Dear Neil Zhang,
>> >>
>> >> On Tue, 9 Jul 2013 14:42:45 +0800, Neil Zhang wrote:
>> >> > support CLOCKSOURCE OF DECLARE for mmp timer.
>> >> >
>> >> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
>> >> > ---
>> >> >  arch/arm/mach-mmp/mmp-dt.c  |    5 ++---
>> >> >  arch/arm/mach-mmp/mmp2-dt.c |    3 +--
>> >> >  arch/arm/mach-mmp/time.c    |   15 ++-------------
>> >> >  3 files changed, 5 insertions(+), 18 deletions(-)
>> >>
>> >> Maybe it would be good to take this opportunity to move
>> >> arch/arm/mach-mmp/time.c into drivers/clocksource/.
>> >
>> > +1
>> >
>> > Or we might want to have a more coordinated move of all clocksource
>> > drivers in arch/arm to drivers/clocksource now, as we have done for
>> > some other subsystems.
>> >
>> >         Arnd
>>
>> I already sent some patches on this. But I didn't get response yet. I'll rebase
>> them and send them again. I hope that they could be merged in this cycle.
>>
>> Regards
>> Haojian
>
> Will you submit a patch to move it by yourself or let me update the patch to
> move it to drivers/clocksource in next version?
>
> Best Regards,
> Neil Zhang

Not one patch. There're a couples of patches. They are depandant each other.

I don't have time to rebase them in these two weeks. Go ahead to rebase all
your patches on mine.

Regards
Haojian
