Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaBMLG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:06:28 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:36967 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaBMLG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:06:26 -0500
Date: Thu, 13 Feb 2014 11:06:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 7/7] devicetree: bindings: Document PM8921/8058 PMICs
Message-ID: <20140213110619.GI32508@lee--X1>
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
 <1389206270-3728-8-git-send-email-sboyd@codeaurora.org>
 <20140211092937.GG32042@lee--X1>
 <20140213053813.GB14769@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140213053813.GB14769@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +- interrupts:
> > > +	Usage: required
> > > +	Value type: <prop-encoded-array>
> > 
> > Either provide an example or a comment to see the description of
> > #interrupt-cells 
> 
> It is part of the example. We also state that the format is
> defined by the interrupt parent binding.

Okay, fair enough.

> > > +	Definition: specifies the interrupt that indicates a subdevice
> > > +		    has generated an interrupt (summary interrupt). The
> > > +		    format of the specifier is defined by the binding document
> > > +		    describing the node's interrupt parent.
> > > +
> > > +- #interrupt-cells:
> > > +	Usage: required
> > > +	Value type : <u32>
> > > +	Definition: must be 2. Specifies the number of cells needed to encode
> > > +		    an interrupt source. The 1st cell contains the interrupt
> > > +		    number. The 2nd cell is the trigger type and level flags
> > > +		    encoded as follows:
> > > +
> > > +			1 = low-to-high edge triggered
> > > +			2 = high-to-low edge triggered
> > > +			4 = active high level-sensitive
> > > +			8 = active low level-sensitive
> > 
> > Actually I'd prefer if you used the definitions in:
> >   dt-bindings/interrupt-controller/irq.h
> 
> These match the #defines in that file. I'd like to be explicit
> about the numbers to prevent people from thinking they have to
> use #defines and to match what other irq controllers have done
> (gic, atmel-aic, etc.)

I believe people _do_ have to use the #defines? Is there a good reason
for you not wanting to use them?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
