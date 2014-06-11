Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaFKToL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:44:11 -0400
Received: from relay2.sgi.com ([192.48.180.65]:46223 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752038AbaFKToJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:44:09 -0400
Date: Wed, 11 Jun 2014 14:44:07 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/misc/sgi-gru/grukdump.c: remove
 unnecessary test on unsigned int
Message-ID: <20140611194407.GA10097@sgi.com>
References: <1402512422-15990-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402512422-15990-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Wed, Jun 11, 2014 at 08:47:02PM +0200, Fabian Frederick wrote:
> unsigned value is never < 0
> 
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/misc/sgi-gru/grukdump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-gru/grukdump.c b/drivers/misc/sgi-gru/grukdump.c
> index a3700a5..e0e0e7e 100644
> --- a/drivers/misc/sgi-gru/grukdump.c
> +++ b/drivers/misc/sgi-gru/grukdump.c
> @@ -196,7 +196,7 @@ int gru_dump_chiplet_request(unsigned long arg)
>  		return -EFAULT;
>  
>  	/* Currently, only dump by gid is implemented */
> -	if (req.gid >= gru_max_gids || req.gid < 0)
> +	if (req.gid >= gru_max_gids)
>  		return -EINVAL;
>  
>  	gru = GID_TO_GRU(req.gid);
> -- 
> 1.8.4.5
