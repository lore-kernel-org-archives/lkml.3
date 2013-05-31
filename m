Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3EaLyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:54:32 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45113 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3EaLyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130531114037.GC7131@gmail.com>
References: <20130524074331.GL14575@console-pimps.org>
	<20130529210115.GC28027@sgi.com>
	<alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	<20130529224645.GA16582@sgi.com>
	<alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
	<1369880172.17397.11.camel@linux-s257.site>
	<20130530221737.GA11105@sgi.com>
	<alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
	<20130531101250.GD30394@gmail.com>
	<alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
	<20130531114037.GC7131@gmail.com>
Date: Fri, 31 May 2013 07:54:22 -0400
Message-ID: <CA+5PVA7d6=5ruagDeFPvpcxOLu5AkJVfyVgqvjXhheh9n_apjg@mail.gmail.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable info
 to runtime code
From: Josh Boyer <jwboyer@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Russ Anderson <rja@sgi.com>,
        joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        x86 <x86@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 7:40 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Jiri Kosina <jkosina@suse.cz> wrote:
>
>> On Fri, 31 May 2013, Ingo Molnar wrote:
>>
>> > > Unfortunately that means that you can as well throw the patch away
>> > > completely.
>> > >
>> > > The sole point is to run the QueryVariableInfo() from the boot
>> > > environment, in order to obtain more accurate information. And it's
>> > > a valid thing to do, according to UEFI specification.
>> >
>> > So this change needs to be reverted or fixed.
>>
>> I don't think anyone is arguing against that.
>
> The statement I replied to above can be fairly read as arguing against it.
>
> Anyway, given that the fix (workaround) from Boris seems elaborate so late
> in the v3.10 cycle, does everyone else agree with a revert as well?

If you go with a revert, please make sure to tag it for stable to it
gets picked up with 3.9.y.

josh
