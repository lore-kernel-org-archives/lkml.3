Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab3BKRiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:38:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38587 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757846Ab3BKRio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:38:44 -0500
Message-ID: <51192B95.1000103@zytor.com>
Date: Mon, 11 Feb 2013 09:34:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
References: <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au> <20130208145539.GC30334@gmail.com> <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com> <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com> <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com> <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com> <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com> <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com> <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com> <20130211122654.GA5802@gmail.com> <20130211125627.GA7583@gmail.com> <1360588699.7383.52.camel@shinybook.infradead.org> <CA+55aFz1pnqdrXCEQThZc3S2r6kQPiDtOKacJQtHpPbjpXkmqg@mail.gmail.com>
In-Reply-To: <CA+55aFz1pnqdrXCEQThZc3S2r6kQPiDtOKacJQtHpPbjpXkmqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 08:34 AM, Linus Torvalds wrote:
> On Mon, Feb 11, 2013 at 5:18 AM, David Woodhouse <dwmw2@infradead.org> wrote:
>>
>> That's complete nonsense. If you want to use pieces of the kernel
>> infrastructure, then just *take* them. There are loads of projects which
>> use the kernel config tools, for example. There's no need to be *in* the
>> kernel repo.
>
> Exactly. I do *not* want a abstraction layer just because somebody
> wants to use it. It causes idiotic guards in the header files etc. We
> already had that pain with the user-level header inclusions etc.
>
> Just copy it.
>

The UAPI work and "make headers_install" already has cleaned things up 
immensely.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

