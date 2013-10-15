Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab3JOGEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:04:30 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52796 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:04:28 -0400
Date: Tue, 15 Oct 2013 08:04:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
Message-ID: <20131015060425.GB3866@gmail.com>
References: <20131011013954.GA28902@www.outflux.net>
 <tip-d751c169e9a6f0f853346f1184881422bd10b3c2@git.kernel.org>
 <20131014083035.GA20976@gmail.com>
 <007cdb12-9fc7-4744-8686-695891b926a3@email.android.com>
 <525C1BC1.6090501@zytor.com>
 <CAGXu5j+tQfUpmem85WK5-ootoJM1mCH6BPDr3pfR2sHwoFy_8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+tQfUpmem85WK5-ootoJM1mCH6BPDr3pfR2sHwoFy_8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> On Mon, Oct 14, 2013 at 9:28 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 10/14/2013 07:19 AM, H. Peter Anvin wrote:
> >> My guess is that the 95 addresses are randomized and the 82 address is an address which failed to relocate.
> >
> >> ffffffff82a04a58 is:
> >> ffffffff82a03000 t init_per_cpu__gdt_page
> >
> >
> > Specifically, it looks like the percpu stuff isn't getting set up correctly.
> 
> It wouldn't surprise me if there are even more percpu things to fix.
> It's the main area we've continued to trip over while working on this
> with various linkers. Which linker and version are you seeing this
> with?

The failure I saw triggered with fairly modern userspace:

 GNU ld version 2.23.52.0.1-9.fc19 20130226

 gcc version 4.8.1 20130603 (Red Hat 4.8.1-1) (GCC) 

Thanks,

	Ingo
