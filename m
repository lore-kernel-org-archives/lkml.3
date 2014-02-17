Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaBQGXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:23:17 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:58660 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaBQGXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:23:16 -0500
X-Greylist: delayed 683 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 01:23:15 EST
X-Original-SENDERIP: 10.177.220.200
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 17 Feb 2014 15:23:24 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] slab: move up code to get kmem_cache_node in
 free_block()
Message-ID: <20140217062324.GC3468@lge.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1392361043-22420-4-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.02.1402141518400.13935@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402141518400.13935@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 03:19:02PM -0800, David Rientjes wrote:
> On Fri, 14 Feb 2014, Joonsoo Kim wrote:
> 
> > node isn't changed, so we don't need to retreive this structure
> > everytime we move the object. Maybe compiler do this optimization,
> > but making it explicitly is better.
> > 
> 
> Would it be possible to make it const struct kmem_cache_node *n then?

Hello, David.

Yes, it is possible.
If I send v2, I will change it.

Thanks.
