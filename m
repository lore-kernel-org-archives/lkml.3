Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaI3Xtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 19:49:52 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42387 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751004AbaI3Xtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 19:49:49 -0400
Message-ID: <542B4194.8070604@hurleysoftware.com>
Date: Tue, 30 Sep 2014 19:49:40 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Akinobu Mita <akinobu.mita@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com> <5426CA0A.7000806@hurleysoftware.com> <CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com> <54294C0B.1060705@hurleysoftware.com> <CAC5umyjP4OscSC8igVLYPEm-6gqiXt9md46sLu77Vut5UiPb=g@mail.gmail.com> <542ABF77.1020402@hurleysoftware.com> <alpine.DEB.2.11.1410010131380.4455@nanos>
In-Reply-To: <alpine.DEB.2.11.1410010131380.4455@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 07:45 PM, Thomas Gleixner wrote:
> On Tue, 30 Sep 2014, Peter Hurley wrote:
>> I read the UFS Unified Memory Extension v1.0 (JESD220-1) specification and
>> it is not clear to me that using DMA mapping is the right approach to
>> supporting UM, at least on x86.
>>
>> And without a mainline user, the merits of this approach are not evident.
>> I cannot even find a production x86 UFS controller, much less one that
>> supports UME.
>>
>> The only PCI UFS controller I could find (and that mainline supports) is
>> Samsung's x86 FPGA-based test unit for developing UFS devices in a x86 test
>> environment, and not a production x86 design.
> 
> And how is that relevant? That device exists and you have no reason to
> deny it to be supported just because you are not interested in it.
>  
>> Unless there's something else I've missed, I don't think these patches
>> belong in mainline.
> 
> You missed that there is no reason WHY such a device should not be
> supported in mainline.

Mainline already supports this card right now without these patches.

>> Samsung's own roadmap
>> (http://www.slideshare.net/linaroorg/next-gen-mobilestorageufs)
>> mentions nothing about bringing UFS to x86 designs.
> 
> And that's telling you what? 
> 
>    - That we should deny Samsung proper support for their obviously
>      x86 based test card
> 
>    - That we should ignore a JEDEC Standard which is obviously never
>      going to hit x86 land just because you decide it?
> 
> Your argumentation is just ass backwards. Linux wants to support the
> full zoo of hardware including this particular PCI card. Period.
> 
> Whether the proposed patchset is the correct solution to support it is
> a completely different question.

And there is currently no way to determine that because there is no
user in mainline that requires this support.

Which you would understand if you had read more carefully.

Regards,
Peter Hurley

