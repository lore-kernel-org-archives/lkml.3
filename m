Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064AbaI3Xpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:45:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:34055 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaI3Xpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:45:52 -0400
Date: Wed, 1 Oct 2014 01:45:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Hurley <peter@hurleysoftware.com>
cc: Akinobu Mita <akinobu.mita@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
In-Reply-To: <542ABF77.1020402@hurleysoftware.com>
Message-ID: <alpine.DEB.2.11.1410010131380.4455@nanos>
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com> <5426CA0A.7000806@hurleysoftware.com> <CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com> <54294C0B.1060705@hurleysoftware.com> <CAC5umyjP4OscSC8igVLYPEm-6gqiXt9md46sLu77Vut5UiPb=g@mail.gmail.com>
 <542ABF77.1020402@hurleysoftware.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Peter Hurley wrote:
> I read the UFS Unified Memory Extension v1.0 (JESD220-1) specification and
> it is not clear to me that using DMA mapping is the right approach to
> supporting UM, at least on x86.
> 
> And without a mainline user, the merits of this approach are not evident.
> I cannot even find a production x86 UFS controller, much less one that
> supports UME.
> 
> The only PCI UFS controller I could find (and that mainline supports) is
> Samsung's x86 FPGA-based test unit for developing UFS devices in a x86 test
> environment, and not a production x86 design.

And how is that relevant? That device exists and you have no reason to
deny it to be supported just because you are not interested in it.
 
> Unless there's something else I've missed, I don't think these patches
> belong in mainline.

You missed that there is no reason WHY such a device should not be
supported in mainline.

> Samsung's own roadmap
> (http://www.slideshare.net/linaroorg/next-gen-mobilestorageufs)
> mentions nothing about bringing UFS to x86 designs.

And that's telling you what? 

   - That we should deny Samsung proper support for their obviously
     x86 based test card

   - That we should ignore a JEDEC Standard which is obviously never
     going to hit x86 land just because you decide it?

Your argumentation is just ass backwards. Linux wants to support the
full zoo of hardware including this particular PCI card. Period.

Whether the proposed patchset is the correct solution to support it is
a completely different question.

So either you stop this right now and help Akinobu to find the proper
solution or you just go back in your uncontaminated x86 cave and STFU.

Thanks,

	tglx
