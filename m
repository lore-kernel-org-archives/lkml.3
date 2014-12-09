Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbaLIMei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:34:38 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40556 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbaLIMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:34:37 -0500
Date: Tue, 9 Dec 2014 18:04:25 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Adithya K <linux.challenge1@gmail.com>
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        gclement@baobob.org, joe@perches.com, guido@vanguardiasur.com.ar,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Adithya Krishnamurthy <linux.challenge@gmail.com>
Subject: Re: [PATCH 1/1] [PATCH] Staging:vt6655: sparse warning fix
Message-ID: <20141209123425.GA5407@sudip-PC>
References: <1418061805-19768-1-git-send-email-linux.challenge1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418061805-19768-1-git-send-email-linux.challenge1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 11:33:25PM +0530, Adithya K wrote:
> From: Adithya Krishnamurthy <linux.challenge@gmail.com>
> 
> Fixed sparse warning fix.

you should mention what type of warning you have fixed.

sudip
> 
> Signed-off-by: Adithya Krishnamurthy <linux.challenge1@gmail.com>
> ---
> ---
>  drivers/staging/vt6655/device_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
> index 83e4162..a3f5cd8 100644
> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -1669,7 +1669,7 @@ static const struct ieee80211_ops vnt_mac_ops = {
>  	.reset_tsf		= vnt_reset_tsf,
>  };
>  
> -int vnt_init(struct vnt_private *priv)
> +static int vnt_init(struct vnt_private *priv)
>  {
>  	SET_IEEE80211_PERM_ADDR(priv->hw, priv->abyCurrentNetAddr);
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
