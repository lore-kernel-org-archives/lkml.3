Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbbAWQzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:55:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51079 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbbAWQzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:55:53 -0500
Date: Fri, 23 Jan 2015 11:55:45 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen-blk: add myself as maintainer of xen-blk{back/front}
Message-ID: <20150123165545.GA31935@l.oracle.com>
References: <1422029669-24845-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1422029669-24845-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:14:29PM +0100, Roger Pau Monne wrote:
> I've done quite a lot of work in blkfront/blkback, and I usually end up
> looking at the patches, so add myself as maintainer together with Konrad.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you!
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: xen-devel@lists.xenproject.org
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c721042..96e129c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10351,6 +10351,7 @@ F:	drivers/pci/*xen*
>  
>  XEN BLOCK SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> +M:	Roger Pau Monné <roger.pau@citrix.com>
>  L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
>  S:	Supported
>  F:	drivers/block/xen-blkback/*
> -- 
> 1.9.3 (Apple Git-50)
> 
