Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaFSHRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:17:40 -0400
Received: from mx2.parallels.com ([199.115.105.18]:55251 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaFSHRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:17:39 -0400
Date: Thu, 19 Jun 2014 11:17:29 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: slab.h: wrap the whole file with guarding macro
Message-ID: <20140619071729.GB20390@esperanza>
References: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:11:35PM +0400, Andrey Ryabinin wrote:
> Guarding section:
> 	#ifndef MM_SLAB_H
> 	#define MM_SLAB_H
> 	...
> 	#endif
> currently doesn't cover the whole mm/slab.h. It seems like it was
> done unintentionally.
> 
> Wrap the whole file by moving closing #endif to the end of it.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
