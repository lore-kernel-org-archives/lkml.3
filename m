Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaKCUmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:42:53 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:48650 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaKCUmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:42:50 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411032138010.5308@nanos>
References: <cover.1414618407.git.luto@amacapital.net> <9c448d5643d0fdb618f8cde9a54c21d2bcd486ce.1414618407.git.luto@amacapital.net>
 <alpine.DEB.2.11.1411032124350.5308@nanos> <CALCETrVHdk2izoGonfjPU5dTVcvAtycyia088FHMedDA4t-WAQ@mail.gmail.com>
 <alpine.DEB.2.11.1411032138010.5308@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 12:42:27 -0800
Message-ID: <CALCETrU_jrEjhGw8QjzEnyfBD8=A8Mh1fYQhEhbmEJbBLqKAhw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] x86_64,vsyscall: Rewrite comment and clean up
 headers in vsyscall code
To: Thomas Gleixner <tglx@linutronix.de>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 12:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 3 Nov 2014, Andy Lutomirski wrote:
>> On Mon, Nov 3, 2014 at 12:31 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Wed, 29 Oct 2014, Andy Lutomirski wrote:
>> >
>> >> vsyscall_64.c is just vsyscall emulation.  Tidy it up accordingly.
>> >>
>> >> If my comment editing offends anyone, let me know and I can fix it.
>> >>
>> >> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >> ---
>> >>  arch/x86/kernel/vsyscall_64.c | 51 +++++++++++++++----------------------------
>> >>  1 file changed, 18 insertions(+), 33 deletions(-)
>> >>
>> >> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
>> >> index 2d912629c96e..ee622f8183f3 100644
>> >> --- a/arch/x86/kernel/vsyscall_64.c
>> >> +++ b/arch/x86/kernel/vsyscall_64.c
>> >> @@ -1,52 +1,37 @@
>> >>  /*
>> >> - *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
>> >> - *  Copyright 2003 Andi Kleen, SuSE Labs.
>> >> + * Mostly copyright (c) 2012-2014 Andy Lutomirski <luto@amacapital.net>
>> >
>> > We usualy leave the old copyright notices around even if the code
>> > which is related to them has been removed more or less completely.
>> >
>> > So I change this to:
>> >
>> > /*
>> >  * Copyright (c) 2012-2014 Andy Lutomirski <luto@amacapital.net>
>> >  *
>> >  * Based on the original implementation:
>> >  *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
>> >  *  Copyright 2003 Andi Kleen, SuSE Labs.
>> >
>> > and apply the whole lot.
>>
>> Would it make more sense to move those copyright notices to
>> arch/x86/vdso/vma.c?  That's where most of the code ended up.
>
> That has already a notice from Andi and I cant figure out what parts
> of that have been written by Andrea. We'll worry about that when we
> remove vsyscall_64.c. Until then the git history will be our friend.

Works for me.

--Andy
