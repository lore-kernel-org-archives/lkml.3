Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935074AbaLLQLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:11:07 -0500
Received: from 8bytes.org ([81.169.241.247]:38733 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbaLLQLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:11:04 -0500
Date: Fri, 12 Dec 2014 17:11:02 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Li, ZhenHua" <zhen-hual@hp.com>
Cc: Baoquan He <bhe@redhat.com>, Takao Indoh <indou.takao@jp.fujitsu.com>,
        dwmw2@infradead.org, vgoyal@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20141212161102.GC24292@8bytes.org>
References: <545ACF66.9050509@jp.fujitsu.com>
 <545AD061.4000102@hp.com>
 <545AD353.8060207@jp.fujitsu.com>
 <545AD8D3.90709@hp.com>
 <545B2885.8070009@jp.fujitsu.com>
 <545B2C07.1070701@hp.com>
 <5465A0E0.4020001@hp.com>
 <20141117133858.GA31920@8bytes.org>
 <20141210084652.GA25091@dhcp-16-105.nay.redhat.com>
 <548A521B.5020705@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548A521B.5020705@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 10:25:31AM +0800, Li, ZhenHua wrote:
> Sorry I have no plan yet.
> Could you send me your logs on your AMD system?

> On 12/10/2014 04:46 PM, Baoquan He wrote:
> >This issue happens on AMD iommu too, do you have any plans or
> >thoughts on that?

I think the best approach for now is to get a prove-of-concept on the
VT-d driver. If it works there the way we expect, we can implement the
same handling in the AMD driver. But I see no reason to hold back the
VT-d patches until it is also fixed for AMD systems.


	Joerg


