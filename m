Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3GLOb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:31:26 -0400
Received: from 8bytes.org ([85.214.48.195]:34302 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab3GLObZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:31:25 -0400
Date: Fri, 12 Jul 2013 16:31:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: next-20130709 DMAR issues
Message-ID: <20130712143122.GF28811@8bytes.org>
References: <29624.1373475702@turing-police.cc.vt.edu>
 <20130712121419.GA22945@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712121419.GA22945@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul 12 16:31:23 2013
X-DSPAM-Confidence: 0.9978
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51e0133b20861837640754
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the heads-up, Ingo.

On Fri, Jul 12, 2013 at 02:14:20PM +0200, Ingo Molnar wrote:
> > Jul 10 12:20:19 turing-police kernel: [    0.021583] DMAR:[fault reason 06] PTE Read access is not set
> > 
> > Now I have 3 extra messages talking about handling a fault status.  lspci says 00:1f.2 is:
> > 
> > 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)

This could be caused by some change in the SATA driver stack. Maybe a
DMA buffer is used after unmap or something.


> > If this doesn't ring any bells, I'l go do the bisect thing...

Yes, a bisection would help here, thanks for doing this.


	Joerg


