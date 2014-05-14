Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaENJcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:32:36 -0400
Received: from 8bytes.org ([85.214.48.195]:45342 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaENJcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:32:32 -0400
Date: Wed, 14 May 2014 11:32:28 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 05/32] x86: irq_remapping: Use irq_alloc/free_hwirq()
Message-ID: <20140514093228.GC6026@8bytes.org>
References: <20140507153622.703412101@linutronix.de>
 <20140507154334.741805075@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507154334.741805075@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 14 11:32:30 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5373382e20861972668632
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, May 07, 2014 at 03:44:07PM -0000, Thomas Gleixner wrote:
> The create_irq variants are going away. Use the new interface. The
> core and arch code already excludes the gsi interrupts from the
> allocation, so no functional change.
> 
> This does not replace the requirement to move x86 to irq domains, but
> it limits the mess to some degree.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: iommu@lists.linux-foundation.org

Can patches 5, 11 and 12 go through the IOMMU tree or do they depend on
the other patches in the series?

If they have other dependencys and can't go through the IOMMU tree feel
free to add my

Acked-by: Joerg Roedel <jroedel@suse.de>


	Joerg


