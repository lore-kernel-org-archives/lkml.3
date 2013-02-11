Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3BKN6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:58:22 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:60319 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab3BKN6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:58:21 -0500
MIME-Version: 1.0
In-Reply-To: <1360588699.7383.52.camel@shinybook.infradead.org>
References: <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
	<20130208145539.GC30334@gmail.com>
	<CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
	<CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
	<CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
	<CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
	<CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
	<CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
	<CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
	<20130211122654.GA5802@gmail.com>
	<20130211125627.GA7583@gmail.com>
	<1360588699.7383.52.camel@shinybook.infradead.org>
Date: Mon, 11 Feb 2013 15:58:20 +0200
Message-ID: <CAJL_dMty3ejGuf8fh0q8jAXsr8OtWq_HQdJHQ88u4Z2BpJzOvg@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
From: Anca Emanuel <anca.emanuel@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
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

[quote]the ultimate goal being to make this new socket family
hypervisor-neutral[/quote]
That was from vmware.
If somebody will make something generic, to please xen, kvm, vmware,
and others in an 15 to 20 years time...
Then a tool like this will be accepted ?

Linus, you know this tool was only for x86.
Now if you look at this:
https://github.com/penberg/linux-kvm/commit/051bdb63879385e12b7e253b72cdde909a5e0b9b
There are other platforms added.
Look here: https://wiki.linaro.org/LEG/Engineering/Virtualization
[quote]kvmtool is used meanwhile[/quote]
They are using it !


On Mon, Feb 11, 2013 at 3:18 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2013-02-11 at 13:56 +0100, Ingo Molnar wrote:
>> To use another, perhaps more applicable analogy:
>>
>> If one has the choice to start a new business in the U.S., it
>> would be reasonable to do that. There's a lot of supporting
>> infrastructure, trust, distribution, standards, enforcement
>> agencies and available workers.
>>
>> Could the same business succeed in Somalia as well? Possibly -
>> if it's a bakery or something similarly fundamental. More
>> complex businesses would likely not thrive very well there.
>>
>> *That* is how I think the current Linux kernel tooling landscape
>> looks like currently in a fair number of places: in many aspects
>> it's similar to Somalia - disjunct entities with not much
>> commonality or shared infrastructure.
>
> That's complete nonsense. If you want to use pieces of the kernel
> infrastructure, then just *take* them. There are loads of projects which
> use the kernel config tools, for example. There's no need to be *in* the
> kernel repo.
>
> And for code-reuse it's even easy enough to automatically extract parts
> of kernel code into a separate repository. See the ecos-jffs2 and
> linux-headers trees, for example, which automatically tracked Linus'
> tree with a certain transformation to make them sane for just pulling
> into the relevant target repositories.
>
> --
> dwmw2
>
