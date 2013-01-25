Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3AYKtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:49:25 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38782 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab3AYKtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:49:19 -0500
Date: Fri, 25 Jan 2013 11:49:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] ioapic-cleanups-for-v3.9
Message-ID: <20130125104915.GB23332@gmail.com>
References: <20130125100040.GA13908@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125100040.GA13908@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joro@8bytes.org> wrote:

> Hi Ingo,
> 
> The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:
> 
>   Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/ioapic-cleanups-for-v3.9

Hm, there are some not so trivial looking conflicts in 
io_apic.c, due to the MSI patches I applied yesterday:

 5ca72c4f7c41 AHCI: Support multiple MSIs
 08261d87f7d1 PCI/MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
 51906e779f2b x86/MSI: Support multiple MSIs in presense of IRQ remapping

Could you please resolve them and resend?

Thanks,

	Ingo
