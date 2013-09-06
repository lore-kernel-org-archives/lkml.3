Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3IFPsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:48:08 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:40956 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956Ab3IFPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:48:06 -0400
Date: Fri, 6 Sep 2013 15:48:04 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 1/4] slab: factor out calculate nr objects in
 cache_estimate
In-Reply-To: <1378447067-19832-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140f3f56efb-1b2035a6-b81f-433f-aa2d-d1af50018b6a-000000@email.amazonses.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com> <1378447067-19832-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.06-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013, Joonsoo Kim wrote:

>  	}
>  	*num = nr_objs;
> -	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
> +	*left_over = slab_size - (nr_objs * buffer_size) - mgmt_size;
>  }

What is the point of this change? Drop it.


