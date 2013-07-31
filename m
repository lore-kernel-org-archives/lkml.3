Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694Ab3GaSIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:08:01 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:48434 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3GaSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130731175232.GA29987@srcf.ucam.org>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
	<3453253.oZLO1ChPbL@vostro.rjw.lan>
	<CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
	<37178266.QXgbv9rq0i@vostro.rjw.lan>
	<CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
	<20130731051421.GA15766@srcf.ucam.org>
	<CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
	<20130731140010.GA24560@srcf.ucam.org>
	<CAMP44s1cLou9TMfLS+FHwPM_b3bG5HN1-hzgvhz0fVRCZ8XqWw@mail.gmail.com>
	<20130731175232.GA29987@srcf.ucam.org>
Date: Wed, 31 Jul 2013 13:07:57 -0500
Message-ID: <CAMP44s1c5pmiC2fvmRi9vFrJXb2zYUT_F=paM2LR_V+7THnFVg@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:52 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jul 31, 2013 at 12:46:04PM -0500, Felipe Contreras wrote:
>
>> That doesn't change the fact that you were wrong, and there *is*
>> actually a way. The fact that you don't want to go there doesn't mean
>> it's not there.
>
> A quirk list will be incomplete, and as such there's no way to guarantee
> whether or not a value of 0 will turn off the backlight. This is why the
> interface doesn't make that guarantee, and why any userspace that
> depends upon that behaviour is behaving incorrectly.

There's no "guarantee" of anything. There is no "guarantee" that your
computer won't freeze when you boot Linux.

>> Here's another: device tree.
>
> There's no functional distinction between device tree and a quirk list
> on x86 - they're both static data sources provided by something other
> than the system firmware. As a result, they will both be incomplete.

So? If something can't be perfect that means we shouldn't even try?

If we can make the software behave consistently for 99% of the
machines out there instead of only 90%, that's better.

>> There are ways to provide a consistent backlight interface to user-space.
>
> No, there aren't.

Yes there are. Not perfectly, nothing is ever perfect, but there are ways.

-- 
Felipe Contreras
