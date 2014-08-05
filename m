Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaHEMXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:23:34 -0400
Received: from relay1.sgi.com ([192.48.180.66]:45981 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaHEMXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:23:33 -0400
Date: Tue, 5 Aug 2014 07:23:31 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] gru: fix %d confusingly prefixed with 0x in format
 string
Message-ID: <20140805122331.GA18464@sgi.com>
References: <20140804133037.GA31042@sgi.com>
 <1407200285-10544-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407200285-10544-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Mon, Aug 04, 2014 at 05:58:05PM -0700, Hans Wennborg wrote:
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/misc/sgi-gru/grumain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
> index ae16c8c..161a940 100644
> --- a/drivers/misc/sgi-gru/grumain.c
> +++ b/drivers/misc/sgi-gru/grumain.c
> @@ -283,7 +283,7 @@ static void gru_unload_mm_tracker(struct gru_state *gru,
>  	spin_lock(&gru->gs_asid_lock);
>  	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
>  	asids->mt_ctxbitmap ^= ctxbitmap;
> -	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
> +	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum %d, asidmap 0x%lx\n",
>  		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
>  	spin_unlock(&gru->gs_asid_lock);
>  	spin_unlock(&gms->ms_asid_lock);
> -- 
> 2.0.0.526.g5318336
