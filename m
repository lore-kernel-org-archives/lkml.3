Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab3BITja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:39:30 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37767 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3BITj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:39:29 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
References: <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
	<20130204184436.GA13256@gmail.com>
	<alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
	<20130204191408.GA32081@kroah.com>
	<20130204191334.GB14837@gmail.com>
	<CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
	<alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
	<20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
	<20130206214646.GA28135@gmail.com>
	<20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
	<20130208145539.GC30334@gmail.com>
	<CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
	<CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
	<CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
	<CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
	<CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
Date: Sat, 9 Feb 2013 21:39:27 +0200
X-Google-Sender-Auth: mQuKEhccFHca6AQbok0iKDRz-SU
Message-ID: <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 8:07 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Everything you said was about how it's more convenient for you and
> Ingo, not at all about why it should be better for anybody else. You
> haven't bothered to even try making it an external project, so it
> doesn't compile that way. You're the only one working on it, so being
> convenient for you is the primary issue. Arguments like that actively
> make me not want to merge it, because they are only arguments for you
> continuing to work the way you have, not arguments for why the project
> would make sense to merge into the main kernel repository.

You are so full of shit it's not even funny.

I am *not* the only person working on the project, far from it. I'm not
trying to make things easy for me, I'm trying to build on the strenghts
of tools/kvm.

The main argument for merging into the main kernel repository has always been
that (we think) it improves the kernel because significant amount of
development is directly linked to kernel code (think KVM ARM port here, for
example). The secondary argument has been to make it easy for kernel developers
to work on both userspace and kernel in tandem (like has happened with vhost
drivers). In short: it speeds up development of Linux virtualization code.

It's not as if there's anything new here so I didn't think it was
necessary to rehash the old arguments. I know you don't have a
compelling reason to pull and that's fine. Just don't come up with these
lame excuses that have nothing to do with reality.

			Pekka
