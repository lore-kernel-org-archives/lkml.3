Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab3JPG4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:56:36 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:43811 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3JPG4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:56:35 -0400
Date: Wed, 16 Oct 2013 08:56:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
Message-ID: <20131016065630.GC22509@gmail.com>
References: <20131011013954.GA28902@www.outflux.net>
 <tip-d751c169e9a6f0f853346f1184881422bd10b3c2@git.kernel.org>
 <20131014083035.GA20976@gmail.com>
 <007cdb12-9fc7-4744-8686-695891b926a3@email.android.com>
 <525C1BC1.6090501@zytor.com>
 <CAGXu5j+tQfUpmem85WK5-ootoJM1mCH6BPDr3pfR2sHwoFy_8A@mail.gmail.com>
 <20131015060425.GB3866@gmail.com>
 <CAGXu5jJx1xkwZD=tC+D69H_6-cGMHD8Sk_9_=8XQxjjDtHpBNA@mail.gmail.com>
 <20131015160329.GA16003@gmail.com>
 <CAGXu5jL2sK86PeEiumJ-4bWQeCYg9BzEBAVOhQeNnHAC2ZPSYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL2sK86PeEiumJ-4bWQeCYg9BzEBAVOhQeNnHAC2ZPSYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> >> > The failure I saw triggered with fairly modern userspace:
> >> >
> >> >  GNU ld version 2.23.52.0.1-9.fc19 20130226
> >> >
> >> >  gcc version 4.8.1 20130603 (Red Hat 4.8.1-1) (GCC)
> >>
> >> Can you try with the gold linker?  When not using Gold, I can produce 
> >> a similar crash with GNU ld ver 2.23.2 but not 2.22.
> >
> > I'm not set up for Gold - but maybe others can try your experiment.
> >
> > If you can see/reproduce the 2.23 crash then maybe that fix will work 
> > for my testcase as well.
> 
> I haven't isolated the problem with 2.23 yet, but I'll start digging.

I've excluded tip:x86/kaslr from tip:master meanwhile.

Thanks,

	Ingo
