Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaBQGOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:14:54 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44500 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaBQGOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:14:53 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-b8-5301a8db6c31
Date: Mon, 17 Feb 2014 15:15:02 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] slab: makes clear_obj_pfmemalloc() just return store
 masked value
Message-ID: <20140217061502.GB3468@lge.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1392361043-22420-3-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.10.1402141225460.12887@nuc>
 <alpine.DEB.2.02.1402141516540.13935@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1402141824300.5204@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402141824300.5204@nuc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 06:26:15PM -0600, Christoph Lameter wrote:
> On Fri, 14 Feb 2014, David Rientjes wrote:
> 
> > Yeah, you don't need it, but don't you think it makes the code more
> > readable?  Otherwise this is going to be just doing
> >
> > 	return (unsigned long)objp & ~SLAB_OBJ_PFMEMALLOC;
> >
> > and you gotta figure out the function type to understand it's returned as
> 
> Isnt there something like PTR_ALIGN() for this case that would make it
> more readable?

I can't find what you want.
I agree with David's opinion and want to keep patch as is.

Thanks.
