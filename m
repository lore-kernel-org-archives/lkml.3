Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3HARhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:37:11 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:38479 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3HARhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130731184724.GA30896@srcf.ucam.org>
References: <3453253.oZLO1ChPbL@vostro.rjw.lan>
	<CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
	<37178266.QXgbv9rq0i@vostro.rjw.lan>
	<CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
	<20130731051421.GA15766@srcf.ucam.org>
	<CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
	<20130731140010.GA24560@srcf.ucam.org>
	<CAMP44s1cLou9TMfLS+FHwPM_b3bG5HN1-hzgvhz0fVRCZ8XqWw@mail.gmail.com>
	<20130731175232.GA29987@srcf.ucam.org>
	<CAMP44s1c5pmiC2fvmRi9vFrJXb2zYUT_F=paM2LR_V+7THnFVg@mail.gmail.com>
	<20130731184724.GA30896@srcf.ucam.org>
Date: Thu, 1 Aug 2013 12:37:04 -0500
Message-ID: <CAMP44s25aRcK2bB=WLMkuD45fztFBNug8prArczRqZqzeEvj3A@mail.gmail.com>
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

On Wed, Jul 31, 2013 at 1:47 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jul 31, 2013 at 01:07:57PM -0500, Felipe Contreras wrote:
>> If we can make the software behave consistently for 99% of the
>> machines out there instead of only 90%, that's better.
>
> If we can't make an interface 100% consistent, we shouldn't pretend that
> the interface is 100% consistent. We can't, and so we don't. Setting a
> backlight value of 0 may turn the screen off, and userspace needs to
> deal with that.

This is insanity; we can never guarantee 100% of anything.

Better is better. And 99% is better than 90%

% git grep quirks | wc -l
1585

Moreover, Linux already does quirks, and when there are quirks it
means there's no 100% guarantee of the thing working as it should;
hence the need for quirks, which is never complete, never 100%.

Anyway, screw the users, right? All you care about is that the code
looks good to you.

If we care about the users, we would provide a consistent interface,
where 0 means the same thing on all the backlight drivers. If all we
can do is provide this consistency 99% of the time through quirks,
that is the way to go.

-- 
Felipe Contreras
