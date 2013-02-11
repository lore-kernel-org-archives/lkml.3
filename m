Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3BKR0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:26:55 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:35038 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab3BKR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:26:54 -0500
MIME-Version: 1.0
In-Reply-To: <1360601199.4156.24.camel@i7.infradead.org>
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
	<CAOJsxLFzc_39tuQazCKe+vO0evWhWwW9QasFiEqCgjKye9iNDg@mail.gmail.com>
	<1360601199.4156.24.camel@i7.infradead.org>
Date: Mon, 11 Feb 2013 19:26:53 +0200
Message-ID: <CAJL_dMus6i4G4FcoYRaXn8=dMpqzoXRw9mZTuCykNbk67oARFQ@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
From: Anca Emanuel <anca.emanuel@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, will you help to the project ?
Talk to Linaro guys.

On Mon, Feb 11, 2013 at 6:46 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2013-02-11 at 16:47 +0200, Pekka Enberg wrote:
>> On Mon, Feb 11, 2013 at 2:26 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> > IIRC Windows support for kmvtool is work in progress - some
>> > patches already got applied.
>>
>> People are working on SeaBIOS support which is just one part of
>> running Windows. But yeah, we'll hopefully support non-Linux guest at
>> some point.
>
> <digression>
>
> You're probably better off focusing on OVMF rather than just SeaBIOS.
>
> SeaBIOS has CSM support now, so it can provide 'legacy' BIOS services
> under OVMF. So if OVMF runs, you get both EFI and legacy support.
>
> --
> dwmw2
