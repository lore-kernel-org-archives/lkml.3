Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3H3NrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:47:22 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:35221 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016Ab3H3NrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:47:21 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Aug 2013 09:47:21 EDT
Date: Fri, 30 Aug 2013 13:37:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/6] slab/block: Add and use kmem_cache_zalloc_node
In-Reply-To: <35769f9779144ace313671235f6508ba683e752b.1377806578.git.joe@perches.com>
Message-ID: <00000140cf71c343-f6cdd204-a553-49b0-bd0b-28492d6d97fe-000000@email.amazonses.com>
References: <cover.1377806578.git.joe@perches.com> <35769f9779144ace313671235f6508ba683e752b.1377806578.git.joe@perches.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Joe Perches wrote:

> Create and use kmem_cache_zalloc_node utility to be
> acompatible style with all the zalloc equivalents
> for kmem_cache_zalloc.

Well I thought more along the lines of dropping the *_zalloc in favor of
__GFP_ZERO but if this is more convenient then I have no objections.

Acked-by: Christoph Lameter <cl@linux.com>
