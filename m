Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaLJItO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:49:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbaLJItL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:49:11 -0500
Date: Wed, 10 Dec 2014 16:46:52 +0800
From: Baoquan He <bhe@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Li, ZhenHua" <zhen-hual@hp.com>, Takao Indoh <indou.takao@jp.fujitsu.com>,
        dwmw2@infradead.org, vgoyal@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20141210084652.GA25091@dhcp-16-105.nay.redhat.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
 <20141022100525.GD9060@dhcp-16-116.nay.redhat.com>
 <545ACF66.9050509@jp.fujitsu.com>
 <545AD061.4000102@hp.com>
 <545AD353.8060207@jp.fujitsu.com>
 <545AD8D3.90709@hp.com>
 <545B2885.8070009@jp.fujitsu.com>
 <545B2C07.1070701@hp.com>
 <5465A0E0.4020001@hp.com>
 <20141117133858.GA31920@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117133858.GA31920@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg, ZhenHua,

This issue happens on AMD iommu too, do you have any plans or
thoughts on that?

Thanks
Baoquan

On 11/17/14 at 02:38pm, Joerg Roedel wrote:
> On Fri, Nov 14, 2014 at 02:27:44PM +0800, Li, ZhenHua wrote:
> > I am working following  your directions:
> > 
> > 1.  If the VT-d driver finds the IOMMU enabled, it reuses its root entry
> > table, and do NOT disable-enable iommu. Other data will be copied.
> > 
> > 2. When a device driver issues the first dma_map command for a
> > device, we assign a new and empty page-table, thus removing all
> > mappings from the old kernel for the device.
> > 
> > Please let me know if I get something wrong.
> 
> Yes, this sounds right. Happily waiting for patches :)
> 
> 
> 	Joerg
> 
