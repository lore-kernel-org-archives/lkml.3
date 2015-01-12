Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbbALTG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:06:27 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:64069 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbbALTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:06:06 -0500
MIME-Version: 1.0
In-Reply-To: <20150112124256.GB13360@arm.com>
References: <20150109121348.GD12942@leverpostej>
	<CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com>
	<54AFE53A.4020004@redhat.com>
	<20150109175702.GA27787@leverpostej>
	<54B01FF0.3020900@arm.com>
	<20150109194333.GA23028@arm.com>
	<54B09CA3.1060501@redhat.com>
	<CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com>
	<20150110133742.GA6999@arm.com>
	<CA+55aFxBA6F4Kr89iZwPPeBnkiRO4GnrbUSd0CqVG-LD6ZQyiw@mail.gmail.com>
	<20150112124256.GB13360@arm.com>
Date: Tue, 13 Jan 2015 08:06:05 +1300
X-Google-Sender-Auth: I6ryPslb4CU2MpVznk-4Ic53acY
Message-ID: <CA+55aFxD63S0PE4zBnEw2jn3pPSALO0BdxY7tP++8wKVdRKJ5g@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Laszlo Ersek <lersek@redhat.com>, Mark Langsdorf <mlangsdo@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>, Dave Hansen <dave@sr71.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 1:42 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> Linus: this moves the tlb->end check back into tlb_flush_mmu_tlbonly.
> How much do you hate that?

So I'm ok with it, as long as we don't have a performance regression.

Your "don't bother freeing when the batch is empty" should hopefully
be fine. Dave, does that work for your case?

           Linus
