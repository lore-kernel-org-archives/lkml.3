Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3JPOxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:53:11 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58974 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3JPOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <20131016065630.GC22509@gmail.com>
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
	<20131016065630.GC22509@gmail.com>
Date: Wed, 16 Oct 2013 07:53:07 -0700
X-Google-Sender-Auth: KM8J1aiGCNmJKLo_Kathie5gI3M
Message-ID: <CAGXu5jLHmF7EtS8jmT_v5GTcFFxEBSmPbHuHvot2iYtmkvxmig@mail.gmail.com>
Subject: Re: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 11:56 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> >> > The failure I saw triggered with fairly modern userspace:
>> >> >
>> >> >  GNU ld version 2.23.52.0.1-9.fc19 20130226
>> >> >
>> >> >  gcc version 4.8.1 20130603 (Red Hat 4.8.1-1) (GCC)
>> >>
>> >> Can you try with the gold linker?  When not using Gold, I can produce
>> >> a similar crash with GNU ld ver 2.23.2 but not 2.22.
>> >
>> > I'm not set up for Gold - but maybe others can try your experiment.
>> >
>> > If you can see/reproduce the 2.23 crash then maybe that fix will work
>> > for my testcase as well.
>>
>> I haven't isolated the problem with 2.23 yet, but I'll start digging.
>
> I've excluded tip:x86/kaslr from tip:master meanwhile.

Are you able to test the patch I sent? It fixed it for my ld 2.23
reproduction case.

-Kees

-- 
Kees Cook
Chrome OS Security
