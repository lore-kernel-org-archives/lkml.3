Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaKQNjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:39:04 -0500
Received: from 8bytes.org ([81.169.241.247]:53263 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbaKQNjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:39:01 -0500
Date: Mon, 17 Nov 2014 14:38:59 +0100
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
Message-ID: <20141117133858.GA31920@8bytes.org>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
 <20141022100525.GD9060@dhcp-16-116.nay.redhat.com>
 <545ACF66.9050509@jp.fujitsu.com>
 <545AD061.4000102@hp.com>
 <545AD353.8060207@jp.fujitsu.com>
 <545AD8D3.90709@hp.com>
 <545B2885.8070009@jp.fujitsu.com>
 <545B2C07.1070701@hp.com>
 <5465A0E0.4020001@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5465A0E0.4020001@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 02:27:44PM +0800, Li, ZhenHua wrote:
> I am working following  your directions:
> 
> 1.  If the VT-d driver finds the IOMMU enabled, it reuses its root entry
> table, and do NOT disable-enable iommu. Other data will be copied.
> 
> 2. When a device driver issues the first dma_map command for a
> device, we assign a new and empty page-table, thus removing all
> mappings from the old kernel for the device.
> 
> Please let me know if I get something wrong.

Yes, this sounds right. Happily waiting for patches :)


	Joerg

