Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaJQHXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:23:16 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:56954 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQHXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:23:13 -0400
MIME-Version: 1.0
In-Reply-To: <8037374.M9KdRGnRWV@phil>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
	<20141015140337.GI27755@sirena.org.uk>
	<CABgxDoKen1Ub1ptG85-oMhUcRkX7tsZ6o51OJcOX2jZkZi0JGg@mail.gmail.com>
	<8037374.M9KdRGnRWV@phil>
Date: Fri, 17 Oct 2014 09:23:12 +0200
Message-ID: <CABgxDo+9Dx7h+KXo+YYVLb3snimNV1PDxv+d1iQ2pY8P395pdQ@mail.gmail.com>
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff capability
From: PERIER Romain <romain.perier@gmail.com>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        robh <robh@kernel.org>, mark.rutland@arm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

Oh sure, no problem. It was just to understand better how things will happen ;)
If my patches needs to be rebased, will do, of course.

Have a nice day,
Romain

2014-10-17 8:06 GMT+02:00 Heiko Stübner <heiko@sntech.de>:
> Hi Romain,
>
> Am Freitag, 17. Oktober 2014, 08:01:31 schrieb PERIER Romain:
>> Hi all,
>>
>> I am just curious but where do you plan to merge this serie ? in
>> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git ?
>
> The single dts patch will be going into my dts branch and the rest will go
> through Mark's regulator tree. As Mark said, he'll try to apply these again
> once 3.18-rc1 is released and if it still doesn't apply then, he'll probably
> ask you to rebase them onto the regulator tree [which will at the time include
> everything that is in -rc1].
>
>
> Heiko
>
>
>
>> 2014-10-15 16:03 GMT+02:00 Mark Brown <broonie@kernel.org>:
>> > On Wed, Oct 15, 2014 at 03:56:03PM +0200, Heiko Stübner wrote:
>> >> Am Mittwoch, 15. Oktober 2014, 15:42:45 schrieb Mark Brown:
>> >> > I guess I should apply these (except the DTS update) since the first
>> >> > user that's being added is a regulator driver?
>> >>
>> >> I'd think so.
>> >> In any case, I'll take the "ARM: dts: ..." patch if you take the others.
>> >
>> > Sounds like a plan.  I just tried applying and got some conflicts but
>> > I'm guessing that this is due to changes that are landing in the merge
>> > window so I'll try again once -rc1 is out.
>
