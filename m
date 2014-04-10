Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161132AbaDJTu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:50:26 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:48770 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030242AbaDJTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuOaUke-W1W0o=1rhhk43Fy_RAYLdfhXQjdhy2xjHxP0oWA@mail.gmail.com>
References: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
 <CAE9FiQXmO_sSCnd-0NvXKmyeLP0m4XGRRkAgqSiMkfeTcvXs+A@mail.gmail.com>
 <CAOULuOaeBPpuiYc_Aru+awBDf=Ahbok-UjgY9o7gfO4VMctoqg@mail.gmail.com>
 <CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
 <CA+55aFx_zAO0iJVi==4X-bYFTopgaOCopCdUBbqUwKfOrXRYqw@mail.gmail.com>
 <20140329171903.GA10551@google.com> <CAOULuOaUke-W1W0o=1rhhk43Fy_RAYLdfhXQjdhy2xjHxP0oWA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 10 Apr 2014 13:50:01 -0600
Message-ID: <CAErSpo6XjtrzSJE6n5aCMzketKv+rPt5eVvrzOQgUnviiRTWnA@mail.gmail.com>
Subject: Re: BAR 14: can't assign mem (size 0x200000)
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 6:14 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>> On Sat, Mar 29, 2014 at 09:41:20AM -0700, Linus Torvalds wrote:
>
>>> Parag, can you add a WARN_ON_ONCE() to that message, so that we see
>>> what the call chain is for it.

Parag, did you ever try this?

> ...
> Not sure if Ubuntu includes any patches on top of 3.11 mainline that
> make a difference to this issue - but in case they don't this might be
> a regression.

I doubt that Ubuntu includes any patches relevant to this issue.

Even though it doesn't seem to cause any problems, we're going to get
a lot of complaints about these scary-looking messages when resuming,
so I think we should figure this out and fix it.

Bjorn
