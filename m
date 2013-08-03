Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3HCWdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 18:33:40 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:63601 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3HCWdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 18:33:38 -0400
MIME-Version: 1.0
In-Reply-To: <2523721.mjZMWxdZdS@vostro.rjw.lan>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan>
	<2185529.xKyHXi1s1o@vostro.rjw.lan>
	<CAMP44s3LC2XzDrQmJ9iPuT04=WnxZcNj7grx9pE=NTxqG=kSvQ@mail.gmail.com>
	<2523721.mjZMWxdZdS@vostro.rjw.lan>
Date: Sat, 3 Aug 2013 17:33:36 -0500
Message-ID: <CAMP44s0hbAjuvMYgaHwQ4A2DjSe1RhzsbXOck+muV_r9mMbAqQ@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 5:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, August 03, 2013 05:06:10 PM Felipe Contreras wrote:
>> On Sat, Aug 3, 2013 at 4:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> [...]
>
>> > Whatever you are thinking you will achieve this way, it doesn't work.
>>
>> It is the reality: v3.7 is broken, v3.8 is broken, v3.9 is broken,
>> v3.10 is broken, v3.11 is going to be broken, v3.12 will probably be
>> broken too, and perhaps even v3.13.
>
> Be precise and say "backlight control on a number of machines in broken in
> those kernels".  Yes, it is.  It needs to be fixed.  Not necessarily your way,
> though.

"My" way, can be done *today*. "Your" way can be done whenever it's ready.

>> Who benefits from this?
>
> Clearly, no one.
>
> And who benefits from your "crusade"?

Who benefits from yours?

It's all very simple; we ask the owners of these machines if
acpi_osi="!Windows 2012" makes things work better, if they do, they go
into the blacklist, if not, they don't. That would fix the problems
for these machines *today*. If later it turns out there are other
issues introduced, they get removed, just like you removed the
intel_backlight switch patch. Igor Gnatenko said he had problems, but
didn't mention which problem. In bug #51231, tons of people reported
that things improved for ThinkPad X230.

And when the proper fix is done, everyone will be happy and we can
drop the blacklist.

Everybody benefits this way.

-- 
Felipe Contreras
