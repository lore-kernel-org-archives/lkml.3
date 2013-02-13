Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab3BMI4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:56:37 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58993 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3BMI4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:56:36 -0500
MIME-Version: 1.0
In-Reply-To: <511B4D76.50504@redhat.com>
References: <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
	<CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
	<CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
	<CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
	<20130211122654.GA5802@gmail.com>
	<CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com>
	<20130211172807.GA9716@gmail.com>
	<CA+55aFx-0-qcYMqH2wnJJ7iAPhoEvD_EQ0xqVW3VGS3G9=_1_w@mail.gmail.com>
	<20130211175856.GC9716@gmail.com>
	<CA+55aFxpH2A5pTkeAt-bapN6Erac7SSEUhS9qaZ6jUhm_0EAtA@mail.gmail.com>
	<20130212095249.GC20039@gmail.com>
	<511B4D76.50504@redhat.com>
Date: Wed, 13 Feb 2013 10:56:34 +0200
X-Google-Sender-Auth: lrH488THq0NMwO8k0iVeFlMewWI
Message-ID: <CAOJsxLEn2c2cDTeeF5ONDe1cA22Cwj-EjE8mUtC3KH9-UQgP9A@mail.gmail.com>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
From: Pekka Enberg <penberg@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:23 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 12/02/2013 10:52, Ingo Molnar ha scritto:
>> Check the list I gave (unmodified):
>>
>> "- Pekka listed new virtio drivers that were done via tools/kvm.
>
> vhost-scsi got in first in tools/kvm, but out-of-tree patches had
> existed for QEMU for more than a year.  It was developed with QEMU.

I think Ingo confused virtio and vhost. IIRC, Asias developed
vhost-blk using tools/kvm.
