Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaKVS7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:59:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaKVS7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:59:23 -0500
Date: Sat, 22 Nov 2014 10:58:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  Staging:skein: Fix trailing  whitespace error
Message-ID: <20141122185800.GA25204@kroah.com>
References: <1416636269-3030-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416636269-3030-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 11:34:29AM +0530, Anjana Sasindran wrote:
>   This patch fixes the checkpatch.pl error:
> 
>   ERROR: trailing whitespace
> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/skein/skein_generic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
> index 7096d5a..8660509 100644
> --- a/drivers/staging/skein/skein_generic.c
> +++ b/drivers/staging/skein/skein_generic.c
> @@ -190,6 +190,7 @@ static int __init skein_generic_init(void)
>  		goto unreg512;
>  
>  	return 0;
> +
>  unreg512:
>  	crypto_unregister_shash(&alg512);
>  unreg256:

Still doesn't apply :(
