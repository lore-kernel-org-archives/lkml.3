Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbbA0I14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:27:56 -0500
Received: from mx2.parallels.com ([199.115.105.18]:41003 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbbA0I1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:27:53 -0500
Date: Tue, 27 Jan 2015 11:27:48 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the akpm-current tree
Message-ID: <20150127082748.GE28978@esperanza>
References: <20150127191243.6fbbf2f6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150127191243.6fbbf2f6@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 27, 2015 at 07:12:43PM +1100, Stephen Rothwell wrote:
> In file included from mm/slab_common.c:26:0:
> mm/slab_common.c: In function 'kmem_cache_destroy':
> mm/slab.h:259:30: warning: right-hand operand of comma expression has no effect [-Wunused-value]
>   for (iter = NULL, tmp = NULL, (root); 0; )
>                               ^

It's already been fixed, please see

https://lkml.org/lkml/2015/1/24/39

Thanks,
Vladimir
