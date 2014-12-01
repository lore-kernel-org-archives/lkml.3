Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaLAMdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:33:31 -0500
Received: from 8bytes.org ([81.169.241.247]:49468 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbaLAMda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:33:30 -0500
Date: Mon, 1 Dec 2014 13:33:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Li, ZhenHua" <zhen-hual@hp.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, bhe@redhat.com,
        dwmw2@infradead.org, vgoyal@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20141201123327.GJ3762@8bytes.org>
References: <20141022100525.GD9060@dhcp-16-116.nay.redhat.com>
 <545ACF66.9050509@jp.fujitsu.com>
 <545AD061.4000102@hp.com>
 <545AD353.8060207@jp.fujitsu.com>
 <545AD8D3.90709@hp.com>
 <545B2885.8070009@jp.fujitsu.com>
 <545B2C07.1070701@hp.com>
 <5465A0E0.4020001@hp.com>
 <20141117133858.GA31920@8bytes.org>
 <547C0B4A.4060303@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C0B4A.4060303@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:31:38PM +0800, Li, ZhenHua wrote:
> After I implement these two steps, there comes a new fault:
> 
> [1.594890] dmar: DRHD: handling fault status reg 2
> [1.594894] dmar: INTR-REMAP: Request device [[41:00.0] fault index 4d
> [1.594894] INTR-REMAP:[fault reason 34] Present field in the IRTE entry
> is clear
> 
> It is caused by similar reason, so I will fix it like fixing the DMAR
> faults: Do NOT disable and re-enable the interrupt remapping, try to
> use data from old kernel.

Yes, that sounds right, thanks. Looking forward to your patches.


	Joerg

