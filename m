Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3EHUMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:12:14 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:39536
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269Ab3EHUMN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:12:13 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh1432I4015I1447Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz177df4h17326ah8275bh8275dhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh906i1155h)
Date: Wed, 8 May 2013 13:12:05 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Tony Lindgren <tony@atomide.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>
Subject: Re: [REGRESSION] SLAB allocator (on Zynq)
References: <9d9b2266-e09e-4366-80ef-3df5db775f25@TX2EHSMHS033.ehs.local>
 <20130508193906.GC32546@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130508193906.GC32546@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <35a77b0e-59cc-4fee-81cf-20c059462d12@DB8EHSMHS016.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 12:39:07PM -0700, Tony Lindgren wrote:
> Hi,
> 
> * Sören Brinkmann <soren.brinkmann@xilinx.com> [130508 12:26]:
> > Hi,
> > 
> > I compiled the latest kernel for Zynq and ran into issues when the SLAB
> > allocator is selected. Booting crashes early with a NULL pointer
> > dereference (boot log attached).
> > Switching to the SLUB allocator resolves the issue (boot log attached).
> 
> There's a fix for this now in lkml thread
> "[GIT PULL] SLAB changes for v3.10":
> 
> http://lkml.org/lkml/2013/5/8/374#
Thanks for the quick response and apologies for not having it found
myself earlier.
With that patch it works again.

	Thanks,
	Sören


