Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaJOGct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:32:49 -0400
Received: from ozlabs.org ([103.22.144.67]:42449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaJOGcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:32:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kyle McMartin <kyle@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] aarch64: filter $x from kallsyms
In-Reply-To: <20140925101417.GG10390@e104818-lin.cambridge.arm.com>
References: <20140916213718.GR22012@redacted.bos.redhat.com> <87r3z9o91q.fsf@rustcorp.com.au> <20140925101417.GG10390@e104818-lin.cambridge.arm.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Oct 2014 15:32:30 +1030
Message-ID: <87oateapsp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:
> On Thu, Sep 18, 2014 at 05:18:57AM +0100, Rusty Russell wrote:
>> Kyle McMartin <kyle@redhat.com> writes:
>> > Similar to ARM, AArch64 is generating $x and $d syms... which isn't
>> > terribly helpful when looking at %pF output and the like. Filter those
>> > out in kallsyms, modpost and when looking at module symbols.
>> >
>> > Seems simplest since none of these check EM_ARM anyway, to just add it
>> > to the strchr used, rather than trying to make things overly
>> > complicated.
>> >
>> > initcall_debug improves:
>> > dmesg_before.txt: initcall $x+0x0/0x154 [sg] returned 0 after 26331 usecs
>> > dmesg_after.txt: initcall init_sg+0x0/0x154 [sg] returned 0 after 15461 usecs
>> >
>> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
>> 
>> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Thanks. Shall I understand that you are ok for me to take it via the
> arm64 tree (or you'd prefer to merge it via your tree)?

Sorry, vacation.  Yes, it was all yours, and I see it in Linus' tree
now.

Thanks,
Rusty.
