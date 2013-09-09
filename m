Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3IIEcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:32:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42549 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3IIEcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:32:20 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-3d-522d4f53c14e
Date: Mon, 9 Sep 2013 13:32:34 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 1/4] slab: factor out calculate nr objects in
 cache_estimate
Message-ID: <20130909043233.GC22390@lge.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1378447067-19832-2-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140f3f56efb-1b2035a6-b81f-433f-aa2d-d1af50018b6a-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140f3f56efb-1b2035a6-b81f-433f-aa2d-d1af50018b6a-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 03:48:04PM +0000, Christoph Lameter wrote:
> On Fri, 6 Sep 2013, Joonsoo Kim wrote:
> 
> >  	}
> >  	*num = nr_objs;
> > -	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
> > +	*left_over = slab_size - (nr_objs * buffer_size) - mgmt_size;
> >  }
> 
> What is the point of this change? Drop it.

Okay. I will drop it.

> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
