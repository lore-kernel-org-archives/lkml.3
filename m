Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3BKQev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:34:51 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42936 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab3BKQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:34:49 -0500
MIME-Version: 1.0
In-Reply-To: <1360588699.7383.52.camel@shinybook.infradead.org>
References: <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com> <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130211122654.GA5802@gmail.com> <20130211125627.GA7583@gmail.com> <1360588699.7383.52.camel@shinybook.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Feb 2013 08:34:28 -0800
X-Google-Sender-Auth: pUS4C5Tevwaunce9bHL5ftSdrRQ
Message-ID: <CA+55aFz1pnqdrXCEQThZc3S2r6kQPiDtOKacJQtHpPbjpXkmqg@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 5:18 AM, David Woodhouse <dwmw2@infradead.org> wrote:
>
> That's complete nonsense. If you want to use pieces of the kernel
> infrastructure, then just *take* them. There are loads of projects which
> use the kernel config tools, for example. There's no need to be *in* the
> kernel repo.

Exactly. I do *not* want a abstraction layer just because somebody
wants to use it. It causes idiotic guards in the header files etc. We
already had that pain with the user-level header inclusions etc.

Just copy it.

            Linus
