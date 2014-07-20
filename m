Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaGTUnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 16:43:33 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60908 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaGTUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 16:43:29 -0400
Date: Sun, 20 Jul 2014 13:43:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] input: remove unnecessary break after goto
Message-ID: <20140720204325.GD18347@core.coreip.homeip.net>
References: <1404837456-7321-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404837456-7321-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:37:36PM +0200, Fabian Frederick wrote:
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thank you.

> ---
>  drivers/input/misc/keyspan_remote.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
> index 01f3b5b..a3fe4a9 100644
> --- a/drivers/input/misc/keyspan_remote.c
> +++ b/drivers/input/misc/keyspan_remote.c
> @@ -392,7 +392,6 @@ static void keyspan_irq_recv(struct urb *urb)
>  
>  	default:
>  		goto resubmit;
> -		break;
>  	}
>  
>  	if (debug)
> -- 
> 1.8.4.5
> 

-- 
Dmitry
