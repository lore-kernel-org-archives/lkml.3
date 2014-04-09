Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbaDIJ0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:26:52 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35870 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaDIJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:26:47 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 9 Apr 2014 02:26:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8187se: fix pointer and return statement's
 syntax
Message-ID: <20140409092639.GA6733@leaf>
References: <1397028355-28063-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397028355-28063-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:25:55AM +0200, Martin Kepplinger wrote:
> Use the common kernel coding style.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
>  drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
> index 0dc5ae4..e6257b3 100644
> --- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
> +++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
> @@ -180,7 +180,7 @@ static inline int ieee80211_put_snap(u8 *data, u16 h_proto)
>  int ieee80211_encrypt_fragment(struct ieee80211_device *ieee,
>  			       struct sk_buff *frag, int hdr_len)
>  {
> -	struct ieee80211_crypt_data* crypt = ieee->crypt[ieee->tx_keyidx];
> +	struct ieee80211_crypt_data *crypt = ieee->crypt[ieee->tx_keyidx];
>  	int res;
>  
>  	/*
> @@ -285,7 +285,7 @@ static int ieee80211_classify(struct sk_buff *skb,
>  
>  	if (!network->QoS_Enable) {
>  		skb->priority = 0;
> -		return(wme_UP);
> +		return wme_UP;
>  	}
>  
>  	if (eh->ether_type == __constant_htons(ETHERTYPE_IP)) {
> @@ -304,7 +304,7 @@ static int ieee80211_classify(struct sk_buff *skb,
>  	}
>  
>  	skb->priority = wme_UP;
> -	return(wme_UP);
> +	return wme_UP;
>  }
>  
>  /* SKBs are added to the ieee->tx_queue. */
> -- 
> 1.7.10.4
> 
