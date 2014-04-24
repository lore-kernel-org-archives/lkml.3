Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbaDXQCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:02:33 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:48544 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbaDXQC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140424152232.GD1735@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-6-git-send-email-lftan@altera.com>
	<20140422143036.GD15745@arch.cereza>
	<CAFiDJ59KHkh549PBezijr-UektFQtQaZ_5fP5qqRvsVC-e2uxw@mail.gmail.com>
	<20140424152232.GD1735@arch.cereza>
Date: Fri, 25 Apr 2014 00:02:13 +0800
X-Google-Sender-Auth: FLXvQ2CQXkiN2LtESflEKaaV63M
Message-ID: <CAFiDJ5-r1SW9qbE4Oghg4cTZUA_qu2RfBj0YLafcFVGweBctoQ@mail.gmail.com>
Subject: Re: [PATCH 08/28] nios2: MMU Fault handling
From: Ley Foon Tan <lftan@altera.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:22 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
>> > I found that it's useful to add some printing here, just as ARM
>> > does. I carry this patch on my kernel:
>> >
>> > +               printk(KERN_INFO "%s: unhandled page fault (%d) at 0x%08lx, cause %ld\n",
>> > +                      current->comm, SIGSEGV, address, cause);
>> > +               show_regs(regs);
>> >
>> > Do you think we could do something like it? Maybe with a compile time option?
>> Yes, this is useful debug message. I can add this.
>> Prefer not to add new compile time option, I think this shouldn't
>> happen frequently.
>
> No, it shouldn't happen frequently. You can take a look at what ARM does.
> They use a DEBUG_USER compile-time option, much more complex than my silly
> proposal.
For now, we can print it always if this shouldn't happen frequently.
Compile time option can be added later if we have more other debug
stuff to print later.

Thanks.

Regard,
Ley Foon
