Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaLRWpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:45:07 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53449 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:45:06 -0500
Date: Thu, 18 Dec 2014 14:45:01 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Aapo Vienamo <aapo.vienamo@iki.fi>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix redundant parens in return in
 amplc_dio200_common.c
Message-ID: <20141218224501.GC6742@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Aapo Vienamo <aapo.vienamo@iki.fi>, abbotti@mev.co.uk,
	hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1418916772-24778-1-git-send-email-aapo.vienamo@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418916772-24778-1-git-send-email-aapo.vienamo@iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aapo,

On Thu, Dec 18, 2014 at 05:32:52PM +0200, Aapo Vienamo wrote:
> This patch fixes a coding style issue found by the checkpatch.pl tool in
> amplc_dio200_common.c by removing the unnecessary parentheses around the
> expression in a return statement.
> 
> Signed-off-by: Aapo Vienamo <aapo.vienamo@iki.fi>
> ---
>  drivers/staging/comedi/drivers/amplc_dio200_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/amplc_dio200_common.c b/drivers/staging/comedi/drivers/amplc_dio200_common.c
> index 26aad70..6eadbbe 100644
> --- a/drivers/staging/comedi/drivers/amplc_dio200_common.c
> +++ b/drivers/staging/comedi/drivers/amplc_dio200_common.c
> @@ -340,7 +340,7 @@ static int dio200_handle_read_intr(struct comedi_device *dev,
>  
>  	comedi_handle_events(dev, s);
>  
> -	return (triggered != 0);
> +	return triggered != 0;
>  }
>  
[...]

When I run checkpatch.pl it doesn't find any errors and the parenthesis
haven't been removed.  How are you running checkpatch.pl?  Are you using
any extra options?

-- 
- Jeremiah Mahler
