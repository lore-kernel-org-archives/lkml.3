Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713Ab3BNPcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:32:11 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:56894 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab3BNPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:32:09 -0500
Message-ID: <511D0374.9070202@codemonkey.ws>
Date: Thu, 14 Feb 2013 09:32:04 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
References: <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com> <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com> <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com> <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com> <20130211122654.GA5802@gmail.com> <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com> <20130211172807.GA9716@gmail.com> <CA+55aFx-0-qcYMqH2wnJJ7iAPhoEvD_EQ0xqVW3VGS3G9=_1_w@mail.gmail.com> <20130211175856.GC9716@gmail.com> <CA+55aFxpH2A5pTkeAt-bapN6Erac7SSEUhS9qaZ6jUhm_0EAtA@mail.gmail.com> <20130212095249.GC20039@gmail.com> <511B4D76.50504@redhat.com> <CAOJsxLEn2c2cDTeeF5ONDe1cA22Cwj-EjE8mUtC3KH9-UQgP9A@mail.gmail.com>
In-Reply-To: <CAOJsxLEn2c2cDTeeF5ONDe1cA22Cwj-EjE8mUtC3KH9-UQgP9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 02:56 AM, Pekka Enberg wrote:
> On Wed, Feb 13, 2013 at 10:23 AM, Paolo Bonzini<pbonzini@redhat.com>  wrote:
>> Il 12/02/2013 10:52, Ingo Molnar ha scritto:
>>> Check the list I gave (unmodified):
>>>
>>> "- Pekka listed new virtio drivers that were done via tools/kvm.
>>
>> vhost-scsi got in first in tools/kvm, but out-of-tree patches had
>> existed for QEMU for more than a year.  It was developed with QEMU.
>
> I think Ingo confused virtio and vhost. IIRC, Asias developed
> vhost-blk using tools/kvm.

We've done extensive performance analysis of vhost-blk and it's not any faster 
than a userspace solution.  This is why it's still not in mainline.

This wasn't noticed with tools/kvm because it's block layer is too simplistic.

In order to get to the point where we're able to do this well in userspace in 
QEMU took tons of bug fixes to the kernel and added features (like 
pread64/pwrite64).

That all happened without QEMU being in the kernel.

Regards,

Anthony Liguori


