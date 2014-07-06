Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaGFR2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:28:19 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41979 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaGFR2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:28:15 -0400
Date: Sun, 6 Jul 2014 20:28:05 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86: Make x2APIC support depend on interrupt remapping
 or guest support
Message-ID: <20140706172805.GF4399@minantech.com>
References: <53B7ADAA.9030101@web.de>
 <20140706151242.GN18167@minantech.com>
 <53B96A2B.4040909@web.de>
 <20140706154112.GO18167@minantech.com>
 <53B96FF5.2050107@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B96FF5.2050107@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 05:49:09PM +0200, Jan Kiszka wrote:
> On 2014-07-06 17:41, Gleb Natapov wrote:
> > On Sun, Jul 06, 2014 at 05:24:27PM +0200, Jan Kiszka wrote:
> >> On 2014-07-06 17:12, Gleb Natapov wrote:
> >>> On Sat, Jul 05, 2014 at 09:47:54AM +0200, Jan Kiszka wrote:
> >>>> From: Jan Kiszka <jan.kiszka@siemens.com>
> >>>>
> >>>> We are able to use x2APIC mode in the absence of interrupt remapping on
> >>>> certain hypervisors. So it if fine to disable IRQ_REMAP without having
> >>>> to give up x2APIC support.
> >>> FWIW I did similar thing back when I added x2apic to KVM:
> >>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-06/msg14579.html
> >>> But was advised against it.
> >>
> >> I don't get the point from that thread.
> > It is not architectural to use x2apic without irq remapping, so Suresh
> 
> Slightly off-topic for this patch: Is this dependency documented
> somewhere? I guess there are broken systems where it can fail, but none
> of the (Intel) boxes I tried so far had problems with x2APIC mode on
> (given APIC IDs < 255) and IRQ remapping disabled.
Not sure I saw that written, but I was told many times that this is so.

--
			Gleb.
