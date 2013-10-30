Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3J3AfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:35:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56926 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab3J3AfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:35:07 -0400
Date: Tue, 29 Oct 2013 17:34:36 -0700
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/6] edac: Document Krait L1/L2 EDAC driver binding
Message-ID: <20131030003436.GB3268@kartoffel>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
 <1383006690-6754-5-git-send-email-sboyd@codeaurora.org>
 <20131029013454.GJ4763@kartoffel>
 <20131029050645.GC21983@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131029050645.GC21983@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 05:06:45AM +0000, Stephen Boyd wrote:
> On 10/28, Mark Rutland wrote:
> > On Tue, Oct 29, 2013 at 12:31:28AM +0000, Stephen Boyd wrote:
> > > +
> > > +Optional properties:
> > > +- interrupt-names: Should contain the interrupt names "l1_irq" and
> > > +  "l2_irq"
> > 
> > As with my comment on the parsing code, I'd prefer that if interrupt-names was
> > present it defined the order of interrupts. Otherwise it's redundant and of no
> > value.
> > 
> > Otherwise, the binding looks fine to me:
> > 
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> How about I just drop the interrupt-names property? It isn't
> adding much and is a holdover from the vendor kernel.

That's also fine given that this is a very specific binding.

Mark.
