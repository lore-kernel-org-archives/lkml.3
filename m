Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab3BKOsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:48:06 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:54528 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3BKOsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:48:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130211122654.GA5802@gmail.com>
References: <20130206214646.GA28135@gmail.com>
	<20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
	<20130208145539.GC30334@gmail.com>
	<CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
	<CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
	<CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
	<CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
	<CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
	<CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
	<CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
	<20130211122654.GA5802@gmail.com>
Date: Mon, 11 Feb 2013 16:47:52 +0200
X-Google-Sender-Auth: qm-QES6hLv149WL2HuFhSLbaVoc
Message-ID: <CAOJsxLFzc_39tuQazCKe+vO0evWhWwW9QasFiEqCgjKye9iNDg@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 2:26 PM, Ingo Molnar <mingo@kernel.org> wrote:
> IIRC Windows support for kmvtool is work in progress - some
> patches already got applied.

People are working on SeaBIOS support which is just one part of
running Windows. But yeah, we'll hopefully support non-Linux guest at
some point.

On Mon, Feb 11, 2013 at 2:26 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> What if somebody tells you that they are really tired of Xen,
>> and actually want to turn kvmtool into *replacement* for Xen
>> instead? [...]
>
> Actually, this was raised by some people - and I think some
> generalization patches were applied already but Pekka might know
> more about that ...

There was some interest but I don't think anybody sent patches for
that. There's no fundamental reason why we couldn't support Xen if
people are interested in working on that.

                        Pekka
