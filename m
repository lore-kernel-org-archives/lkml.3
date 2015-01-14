Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbbANStz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:49:55 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:37462 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbANSty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:49:54 -0500
MIME-Version: 1.0
In-Reply-To: <20150114184714.GD6902@pd.tnic>
References: <5491B4A8.905@amacapital.net> <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org> <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
 <20150114183546.GC6902@pd.tnic> <CALCETrUEfQY-hnmNV9-PfDbEYLa7bVoRcsZc2X0V+mEAbfNH2g@mail.gmail.com>
 <20150114184714.GD6902@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Jan 2015 10:49:32 -0800
Message-ID: <CALCETrVUw=Pg+UqQ-B23dd+o3_ROoziH84B-BdBRqDk5-J=amQ@mail.gmail.com>
Subject: Re: EFI mixed mode + perf = rampant triple faults
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:47 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Jan 14, 2015 at 10:38:25AM -0800, Andy Lutomirski wrote:
>> That's not a real MCE, though -- it happens synchronously instead of
>
> MCE can be synchronous in a sense too, as a result of executing an insn,
> for example, i.e., EIPV bit set.
>
>> at MCE priority with all the associated messiness.  Or is the idea to
>> just stick that in after switching to the 32-bit mode being tested?
>
> Yes, the idea was to simply trigger a real exception after switching to
> 32-bit while still with 64-bit IDT handlers.
>

Seems like a reasonable test to me.

--Andy
