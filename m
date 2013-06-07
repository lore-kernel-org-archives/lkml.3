Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3FGPic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:38:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3FGPib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:38:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] dmaengine/trivial: at_hdmac: add curly brackets to if/else expressions
Date: Fri, 7 Jun 2013 17:38:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1370618898-18296-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1370618898-18296-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306071738.01488.arnd@arndb.de>
X-Provags-ID: V02:K0:j2KgHgYoLvln4iKdAF6ZUKDbvAsNtXM3zbHR7TAHVaS
 DaAs6v05DfxjyR2gSaHClGWChbiHnqbN1rp1VDuxmUPMZhC2yf
 LKg6IF2/9l1dvHmmJeDuSCIq7crapC2c2yr6wnXNTki5W8DUwM
 atoApzY6pw18EeoZrgrWavEDZ/gg55CDfFo3yztq/fMv4NK2La
 73f5Guq+o+76yZ3XwjkGeSsKtRkZqgaRUtvGJkGXtOVxi8kFf+
 4c5XGLKFUTY85om8Exb9W6zrOwbeAWS/6+GzEQY3PHxFiqIDIE
 B+SGHblT4WKbreuOHNZjyDcVEZF58Y7DhC/prk3LV3oBfkQdu2
 GI+gBbqNQValVY1NMnuo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013, Nicolas Ferre wrote:
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 50953a7..b321562 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -299,8 +299,9 @@ static int atc_get_bytes_left(struct dma_chan *chan)
>                 if (atchan->remain_desc < 0) {
>                         ret = -EINVAL;
>                         goto out;
> -               } else
> +               } else {
>                         ret = atchan->remain_desc;
> +               }
>         } else {

Actually the original code is what a lot of people prefer, though I don't
have a reference to back that up.

If one side of the 'else' uses curly braces, the other one should too.
	
	Arnd
