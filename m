Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155AbaJSE3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 00:29:23 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63517 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaJSE3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 00:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <5442FE58.5020700@gaast.net>
References: <54347520.3050109@gaast.net>
	<543AA2FE.20105@gaast.net>
	<20141012204032.GA11171@amd>
	<9751497.0fL0kvsyX7@vostro.rjw.lan>
	<20141015111641.GC7792@gaast.net>
	<CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com>
	<CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com>
	<543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
	<CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
	<544033CF.3080104@gaast.net>
	<CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
	<5442FE58.5020700@gaast.net>
Date: Sat, 18 Oct 2014 21:29:21 -0700
X-Google-Sender-Auth: nXql0unYQlRN3uFAWp015Uoix_o
Message-ID: <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 4:57 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> On 18-10-14 22:28, Yinghai Lu wrote:
>>
>> Please apply attached debug patch on top of v3.17 and boot with
>> "debug ignore_loglevel initcall_debug no_console_suspend".
>>
>> Hope we can find out which nb notifier cause problem.
>>
> Did that. Strangely, or better said, quite annoyingly, I'm now getting no
> output anymore at all on the third resume! :-(
>
> I could try non-serial instead if you think that's worth a shot, but the
> most annoying thing is that my video doesn't get initialised properly after
> resume unless I have the tainting nvidia driver loaded. I could try if
> nouveau helps.

oh no.

Please try to "debug ignore_loglevel no_console_suspend".

Thanks

Yinghai
