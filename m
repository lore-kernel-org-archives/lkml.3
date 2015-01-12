Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbbALTHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:07:22 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50292 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbbALTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:07:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxD63S0PE4zBnEw2jn3pPSALO0BdxY7tP++8wKVdRKJ5g@mail.gmail.com>
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
	<CA+55aFxD63S0PE4zBnEw2jn3pPSALO0BdxY7tP++8wKVdRKJ5g@mail.gmail.com>
Date: Tue, 13 Jan 2015 08:07:12 +1300
X-Google-Sender-Auth: KdnPFzB2Y52pjBjOwDIlyCJ0V34
Message-ID: <CA+55aFw=urngjyQvuOWHP1BBe-tNKy0E4DC0c5PwP+XuvpSmEg@mail.gmail.com>
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

On Tue, Jan 13, 2015 at 8:06 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I'm ok with it, as long as we don't have a performance regression.
>
> Your "don't bother freeing when the batch is empty" should hopefully
> be fine. Dave, does that work for your case?

Oh, and Dave just replied that it's ok. So should I just take it
directly, or expect it through the arm64 tree? Either works for me.

            Linus
