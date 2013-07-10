Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3GJF6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:58:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42991 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3GJF6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <201307092316.20905.arnd@arndb.de>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-3-git-send-email-zhangwm@marvell.com>
	<20130709181434.76f6216d@skate>
	<201307092316.20905.arnd@arndb.de>
Date: Wed, 10 Jul 2013 13:58:39 +0800
Message-ID: <CAN1soZyFztVR1XSw9bDS5JexK0Mdbpr6yevatVf+MnBohwCj1Q@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF DECLARE
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Neil Zhang <zhangwm@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 5:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 09 July 2013, Thomas Petazzoni wrote:
>> Dear Neil Zhang,
>>
>> On Tue, 9 Jul 2013 14:42:45 +0800, Neil Zhang wrote:
>> > support CLOCKSOURCE OF DECLARE for mmp timer.
>> >
>> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
>> > ---
>> >  arch/arm/mach-mmp/mmp-dt.c  |    5 ++---
>> >  arch/arm/mach-mmp/mmp2-dt.c |    3 +--
>> >  arch/arm/mach-mmp/time.c    |   15 ++-------------
>> >  3 files changed, 5 insertions(+), 18 deletions(-)
>>
>> Maybe it would be good to take this opportunity to move
>> arch/arm/mach-mmp/time.c into drivers/clocksource/.
>
> +1
>
> Or we might want to have a more coordinated move of all clocksource
> drivers in arch/arm to drivers/clocksource now, as we have done for some
> other subsystems.
>
>         Arnd

I already sent some patches on this. But I didn't get response yet. I'll rebase
them and send them again. I hope that they could be merged in this cycle.

Regards
Haojian
