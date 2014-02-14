Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaBNSuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:50:07 -0500
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:54763
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbaBNSuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:50:00 -0500
Date: Fri, 14 Feb 2014 12:49:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 9/9] slab: remove a useless lockdep annotation
In-Reply-To: <1392361043-22420-10-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1402141248560.12887@nuc>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com> <1392361043-22420-10-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Joonsoo Kim wrote:

> @@ -921,7 +784,7 @@ static int transfer_objects(struct array_cache *to,
>  static inline struct alien_cache **alloc_alien_cache(int node,
>  						int limit, gfp_t gfp)
>  {
> -	return (struct alien_cache **)BAD_ALIEN_MAGIC;
> +	return NULL;
>  }
>

Why change the BAD_ALIEN_MAGIC?

