Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaEWSke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:40:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaEWSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:40:33 -0400
Date: Fri, 23 May 2014 20:33:46 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique van den Broeck <domdevlin@free.fr>
Cc: Willy Tarreau <willy@meta-x.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: panel: (coding style) Multiple assignments
Message-ID: <20140523113346.GA10649@kroah.com>
References: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
 <1400674201-9560-3-git-send-email-domdevlin@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400674201-9560-3-git-send-email-domdevlin@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 02:10:01PM +0200, Dominique van den Broeck wrote:
> Style-only modifications to comply with checkpatch.pl --strict --file. 
> . Breaks down compound assignments.
> 
> Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
> ---
> Apply on linux-next tree, above:
> commit 4151fa6adc65da14673ece623bbb2acc6936f8be
> "Add linux-next specific files for 20140516"
> 
> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> index 1ac5e25..8d15b04 100644
> --- a/drivers/staging/panel/panel.c
> +++ b/drivers/staging/panel/panel.c
> @@ -664,8 +664,8 @@ static void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
>  {
>  	int d_bit, c_bit, inv;
>  
> -	d_val[0] = c_val[0] = d_val[1] = c_val[1] = 0;
> -	d_val[2] = c_val[2] = 0xFF;
> +	d_val[0] = 0 ; c_val[0] = 0 ; d_val[1] = 0 ; c_val[1] = 0;
> +	d_val[2] = 0xFF; c_val[2] = 0xFF;

Honestly, that's harder to read now, so I'll just leave this all alone
and not apply this patch.

Becides, you got the ; wrong...

thanks,

greg k-h
