Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbbAMWBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:01:33 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:53347 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbAMWBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:01:31 -0500
MIME-Version: 1.0
In-Reply-To: <20150108181657.GE20632@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-2-git-send-email-dvlasenk@redhat.com> <20150108181657.GE20632@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Jan 2015 14:01:09 -0800
Message-ID: <CALCETrXU8p+ttD1n0UoocLN0NucVvLWYBKujmQFA86n1Dzxe=Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86: entry_64.S: delete unused code
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 10:16 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 08, 2015 at 05:25:12PM +0100, Denys Vlasenko wrote:
>> A define, two macros and an unreferenced bit of assembly are gone.
>>
>> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>> CC: Oleg Nesterov <oleg@redhat.com>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: Andy Lutomirski <luto@amacapital.net>
>> CC: Frederic Weisbecker <fweisbec@gmail.com>
>> CC: X86 ML <x86@kernel.org>
>> CC: Alexei Starovoitov <ast@plumgrid.com>
>> CC: Will Drewry <wad@chromium.org>
>> CC: Kees Cook <keescook@chromium.org>
>> CC: linux-kernel@vger.kernel.org
>>
>> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
>
> Acked-by: Borislav Petkov <bp@suse.de>
>

Applied to luto/x86/entry.  We'll see how this "maintenance" thing goes. :)

--Andy

> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
