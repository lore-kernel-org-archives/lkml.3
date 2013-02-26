Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab3BZQ2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:28:04 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:62849 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552Ab3BZQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:28:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130226161049.GA9303@kahuna>
References: <1663657.ypAtqGpGAq@vostro.rjw.lan>
	<1781256.mPQbtiUPYR@vostro.rjw.lan>
	<CA+55aFyzjN_wMH+2RCEA+aNLY0Z7fn4YU7VOtTALbgngn1+vCw@mail.gmail.com>
	<2223198.XmyRLgb3Gv@vostro.rjw.lan>
	<20130226161049.GA9303@kahuna>
Date: Tue, 26 Feb 2013 08:27:59 -0800
X-Google-Sender-Auth: eWBe23NLPdM3vN5qOMB_3RPxmOA
Message-ID: <CA+55aFy24fp+9zXiDmAgvsz6YvWQh2L0BAJ2hAhF7cNSdyMd8w@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 8:10 AM, Nishanth Menon <nm@ti.com> wrote:
> On 16:55-20130226, Rafael J. Wysocki wrote:
>>
>> It says that in "Introduction", but it would be clearer if the title of the
>> doc was something like "Operating Performance Points (OPP) Library".  Nishanth?
>
> Yes indeed. Will the following help? I can post it as an official patch
> if the direction is proper

Yes, this will definitely help. I didn't even find it in the
introduction (Rafael is correct that it is indeed there), because it's
hard to see when you don't know what to scan for and it's in a big
block of text.

I am also happy to note that it is in the Kconfig help and single-line
description. Which wasn't true for the new SATA_ZPODD ("Zero Power
ODD" - what the heck is ODD?) which was another new entry I wondered
about.

It turns out that ODD is an odd TLA for "Optical Disk Drive". I'm sure
it makes perfect sense if you are a SATA person, but it sure doesn't
for any normal human being, even otherwise highly technical ones.

Aaron, Tejun, Jeff, can I ask you to also not use specialized TLA's
without explaining them? Especially in help text and "documentation",
it's very unhelpful to have TLA's that aren't common.

We don't have to explain *all* TLA's, since there's a lot that really
are rather widespread. But there's a big difference between something
like CPU or TLB that have been in generic literature for decades, wrt
OPP and ODD that are specialized terms used inside a very particular
group and haven't been around for very long either.

              Linus
