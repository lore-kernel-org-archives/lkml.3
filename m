Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaAURNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:13:25 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60572 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaAURNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:13:20 -0500
Date: Tue, 21 Jan 2014 17:13:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/4 v3] mfd: tc3589x: Add device tree bindings
Message-ID: <20140121171313.GC27111@lee--X1>
References: <1384265558-10521-1-git-send-email-linus.walleij@linaro.org>
 <CACRpkdZoEwgRALT0R8vWB1aWxR_WCR2U0b1yF0Mr0qNm0LDGug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZoEwgRALT0R8vWB1aWxR_WCR2U0b1yF0Mr0qNm0LDGug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This defines the device tree bindings for the Toshiba TC3589x
> > series of multi-purpose expanders. Only the stuff I can test
> > is defined: GPIO and keypad. Others may implement more
> > subdevices further down the road.
> >
> > This is to complement
> > commit a435ae1d51e2f18414f2a87219fdbe068231e692
> > "mfd: Enable the tc3589x for Device Tree" which left off
> > the definition of the device tree bindings.
> >
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> > ChangeLog v2->v3:
> > - Fix the keys/rows bindings to be u32 rather than
> >   /bits/ 8, inconsistency noted by Mark Rutland.
> > ChangeLog v1->v2:
> > - Include a verbose example in the DT bindings.
> > - Explain why this is a stand-alone bindings patch.
> 
> So will this since Nov 12 uncommented-upon patch be merged or
> do you want me to do some change?
> 
> There was some back-and-forth regarding the (existing, already
> in use) linux-specific input bindings but the only thing I can
> see is some back and forth leaning toward just letting these
> be used.

We still need a DT Ack.

> I am happy to change this in whatever way but no directions
> for two months....

If it had slipped though the gaps, I'd probably suggest poking or
re-sending before the middle of the merge-window though.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
