Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966584AbaFTAK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:10:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966530AbaFTAK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:10:26 -0400
Date: Thu, 19 Jun 2014 17:14:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
Cc: devel@driverdev.osuosl.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8172u: Make ieee80211_crypto_init static
Message-ID: <20140620001426.GA1351@kroah.com>
References: <1402594851-16941-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402594851-16941-1-git-send-email-agimenez@sysvalve.es>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 07:40:49PM +0200, L. Alberto Giménez wrote:
> Fix sparse warning.
> 
> Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
> ---
>  drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
> index 5533221..3be690d 100644
> --- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
> +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
> @@ -200,7 +200,7 @@ static struct ieee80211_crypto_ops ieee80211_crypt_null = {
>  	.owner			= THIS_MODULE,
>  };
>  
> -int __init ieee80211_crypto_init(void)
> +static int __init ieee80211_crypto_init(void)
>  {
>  	int ret = -ENOMEM;

You obviously did not compile this change :(

greg k-h
