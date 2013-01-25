Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3AYLbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:31:12 -0500
Received: from 8bytes.org ([85.214.48.195]:49601 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab3AYLbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:31:08 -0500
Date: Fri, 25 Jan 2013 12:31:05 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] ioapic-cleanups-for-v3.9
Message-ID: <20130125113105.GV25591@8bytes.org>
References: <20130125100040.GA13908@8bytes.org>
 <20130125104915.GB23332@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125104915.GB23332@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jan 25 12:31:06 2013
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51026cfa22971389813339
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:49:15AM +0100, Ingo Molnar wrote:
> Hm, there are some not so trivial looking conflicts in 
> io_apic.c, due to the MSI patches I applied yesterday:
> 
>  5ca72c4f7c41 AHCI: Support multiple MSIs
>  08261d87f7d1 PCI/MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
>  51906e779f2b x86/MSI: Support multiple MSIs in presense of IRQ remapping
> 
> Could you please resolve them and resend?

Will do. I rebase to tip/x86/apic and test again.


	Joerg


