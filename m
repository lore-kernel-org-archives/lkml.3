Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbaIQVlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:41:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29676 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbaIQVlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:41:07 -0400
Date: Thu, 18 Sep 2014 00:40:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Ragnar B. Johannsson" <ragnar@igo.is>
Cc: gregkh@linuxfoundation.org, gdonald@gmail.com, himangi774@gmail.com,
        joe@perches.com, joelpelaez@gmail.com, arnd@arndb.de,
        jmmahler@gmail.com, peter.p.waskiewicz.jr@intel.com,
        antoine@schweitzer-chaput.fr, anarey@gmail.com, c@24.io,
        rickard_strandqvist@spectrumdigital.se, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: rtl8192u: Move ieee80211_crypto_*
 declarations to ieee80211/ieee80211.h
Message-ID: <20140917214027.GM17875@mwanda>
References: <1410989043-53752-1-git-send-email-ragnar@igo.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410989043-53752-1-git-send-email-ragnar@igo.is>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:24:03PM +0000, Ragnar B. Johannsson wrote:

> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
> index bdad3a2..d56c3aac 100644
> --- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
> +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
> @@ -2445,6 +2445,15 @@ extern void ieee80211_tkip_null(void);
>  extern void ieee80211_wep_null(void);
>  extern void ieee80211_ccmp_null(void);
>  
> +extern int ieee80211_crypto_init(void);
> +extern void ieee80211_crypto_deinit(void);
> +extern int ieee80211_crypto_tkip_init(void);
> +extern void ieee80211_crypto_tkip_exit(void);
> +extern int ieee80211_crypto_ccmp_init(void);
> +extern void ieee80211_crypto_ccmp_exit(void);
> +extern int ieee80211_crypto_wep_init(void);
> +extern void ieee80211_crypto_wep_exit(void);
> +

We don't normally put the extern here.  I don't think it adds anything
to the readability.  Let's remove it.

regards,
dan carpenter

