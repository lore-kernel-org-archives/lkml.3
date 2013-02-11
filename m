Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653Ab3BKXct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:32:49 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:41823 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab3BKXcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:32:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130211175856.GC9716@gmail.com>
References: <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130211122654.GA5802@gmail.com> <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com>
 <20130211172807.GA9716@gmail.com> <CA+55aFx-0-qcYMqH2wnJJ7iAPhoEvD_EQ0xqVW3VGS3G9=_1_w@mail.gmail.com>
 <20130211175856.GC9716@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Feb 2013 15:32:26 -0800
X-Google-Sender-Auth: GrhWi0QQYggjnInToq2hiQz1kAI
Message-ID: <CA+55aFxpH2A5pTkeAt-bapN6Erac7SSEUhS9qaZ6jUhm_0EAtA@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 9:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> So basically Pekka optimistically thought it's an eventual 'tit
> for tat', a constant stream of benefits to the kernel, in the
> hope of finding a home in the upstream kernel which would
> further help both projects. The kernel wants to keep the 'tit'
> only though.

Ingo, stop this idiotic nonsense.

You seem to think that "kvmtool is useful for kernel" is somehow relevant.

IT IS TOTALLY IRRELEVANT.

"sparse" is useful for kernel development. "git" is useful for kernel
development. "xterm" is useful for kernel development.

See a pattern? We have tons of tools that are helping develop the
kernel, and for absolutely NONE of them is that at all an argument for
merging them into the kernel.

If the Xen people came and asked me to merge their virtualizer code
into the kernel, I'd call them idiots.

Why is kvmtool so magical that you use this argument for merging it
into the kernel?

It makes no sense.

Yet you continue to use it as if it was somehow an argument for
merging it. Despite the hundreds of projects to the contrary.

So this whole "constant stream of benefits" you talk about is PURE AND
UTTER GARBAGE. And that's not a commentary on whether it is true or
not, it's a commentary on the fact that it is entirely irrelevant to
whether something should be merged.

Merging two projects does not make them easier to maintain. Quite the
reverse. It just ties the maintenance together in irrelevant ways.

                       Linus
