Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab3KNGWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 01:22:37 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3115 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab3KNGWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 01:22:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQMAGdrhFJ5LGc//2dsb2JhbABZgwc4gnSoHQOPKIVDgSgXdIIlAQEFOhwjEAgDDgcDCSUPBSUDIROIAL9nFoxxgQ2BSweEMQOYD5INgzwogSw
Date: Thu, 14 Nov 2013 17:22:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ben Myers <bpm@sgi.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, elder@kernel.org,
        Mark Tinguely <tinguely@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] update xfs maintainers
Message-ID: <20131114062226.GN6188@dastard>
References: <20131107220208.GY1935@sgi.com>
 <527C0F64.3010906@sgi.com>
 <527C4B27.6020205@redhat.com>
 <527CC50D.4060905@redhat.com>
 <20131108180337.GO10553@sgi.com>
 <20131108193424.GA11052@infradead.org>
 <20131108204605.GA1935@sgi.com>
 <527D4E8D.3000109@redhat.com>
 <20131108220309.GB1935@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108220309.GB1935@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 04:03:10PM -0600, Ben Myers wrote:
> From: Ben Myers <bpm@sgi.com>
> 
> xfs: update maintainers 
> 
> Add Dave as maintainer of XFS.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/MAINTAINERS
> ===================================================================
> --- a/MAINTAINERS	2013-11-08 15:20:18.935186245 -0600
> +++ b/MAINTAINERS	2013-11-08 15:22:50.685245977 -0600
> @@ -9387,8 +9387,8 @@ F:	drivers/xen/*swiotlb*
>  
>  XFS FILESYSTEM
>  P:	Silicon Graphics Inc
> +M:	Dave Chinner <dchinner@fromorbit.com>
>  M:	Ben Myers <bpm@sgi.com>
> -M:	Alex Elder <elder@kernel.org>
>  M:	xfs@oss.sgi.com
>  L:	xfs@oss.sgi.com
>  W:	http://oss.sgi.com/projects/xfs

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
