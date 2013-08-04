Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3HDSrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 14:47:06 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:53887 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3HDSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 14:47:05 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130804183708.GI23006@n2100.arm.linux.org.uk>
References: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com>
	<20130803000731.GS23006@n2100.arm.linux.org.uk>
	<20130804125346.GH23006@n2100.arm.linux.org.uk>
	<CAOesGMhNr5-6T9s8Y9jr2pWy=baceuZwGFNj2HtnqU9DbwPLvw@mail.gmail.com>
	<20130804183708.GI23006@n2100.arm.linux.org.uk>
Date: Sun, 4 Aug 2013 11:47:04 -0700
Message-ID: <CAOesGMiDBT9NAhCiVe0mMTk4KXJZVynNaBHqk5+T9a6QYaFZvw@mail.gmail.com>
Subject: Re: Build breakage due to latest ARM fixes
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 11:37 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Aug 04, 2013 at 11:20:21AM -0700, Olof Johansson wrote:
>> On Sun, Aug 4, 2013 at 5:53 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Sat, Aug 03, 2013 at 01:07:31AM +0100, Russell King - ARM Linux wrote:
>> >> I'll look into that.  Obviously, I never build nommu because it isn't
>> >> part of the build system and the nommu platform I do have - OKI67001 -
>> >> doesn't have mainline kernel support.  (And if it did, it would not be
>> >> DT, so I doubt it's submittable.)
>> >
>> > Okay, what I'm going to do is push the OKI67001 stuff into mainline
>> > irrespective of DT or not, so that I can then add noMMU build _and_
>> > boot tests to my build system, which should ensure that problems
>> > like that get detected before they're pushed upstream.
>>
>> That seems like a step backwards. How have !MMU changes been handled
>> until now? Someone external has been relied on for testing?
>
> No, they've had no testing as far as I'm aware.  noMMU never got to the
> stage when it was merged that it had any platforms before Hiyok went
> silent.
>
> The only real testing I'm aware of is when I recreated the OKI67001
> support a while back and got my board to boot.

Uwe has been busy pushing various patches for M3/M4 support, I don't
know how far it is from having some real hardware usable though. Uwe?

> As for qemu, software emulations while nice and convenient don't
> accurately reflect real hardware.

Oh, agreed, it doesn't beat hardware-based testing but in the absence
of hardware it's better than nothing.


-Olof
