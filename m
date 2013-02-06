Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab3BFVfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:35:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31788 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab3BFVft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:35:49 -0500
Date: Wed, 6 Feb 2013 13:35:32 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH] PVH: remove code to map iomem from guest
Message-ID: <20130206133532.694a86c0@mantra.us.oracle.com>
In-Reply-To: <20130206153910.GA23029@konrad-lan.dumpdata.com>
References: <20130130145529.3900dca1@mantra.us.oracle.com>
	<20130206153910.GA23029@konrad-lan.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013 10:39:13 -0500
Konrad Rzeszutek Wilk <konrad@darnok.org> wrote:

> On Wed, Jan 30, 2013 at 02:55:29PM -0800, Mukesh Rathor wrote:
> > It was decided during xen patch review that xen map the iomem
> > transparently, so remove xen_set_clr_mmio_pvh_pte() and the sub
> > hypercall PHYSDEVOP_map_iomem.
> > 
> 
> Grrrr..
> 
> No Signed-off-by??

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>


BTW, thanks a lot konrad for managing this while xen patch is being
reviewed. It's a huge help for me and allows me to focus on xen side.
Appreciate much.

Mukesh
