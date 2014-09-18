Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbaIRPE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:04:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35804 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbaIRPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:04:57 -0400
Date: Thu, 18 Sep 2014 18:04:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Ragnar B. Johannsson" <ragnar@igo.is>
Cc: gregkh@linuxfoundation.org, gdonald@gmail.com, himangi774@gmail.com,
        joe@perches.com, joelpelaez@gmail.com, arnd@arndb.de,
        jmmahler@gmail.com, peter.p.waskiewicz.jr@intel.com,
        antoine@schweitzer-chaput.fr, anarey@gmail.com, c@24.io,
        rickard_strandqvist@spectrumdigital.se, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: rtl8192u: Move ieee80211_crypto_*
 declarations to ieee80211/ieee80211.h
Message-ID: <20140918150416.GN17875@mwanda>
References: <20140917214027.GM17875@mwanda>
 <1411050805-61907-1-git-send-email-ragnar@igo.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411050805-61907-1-git-send-email-ragnar@igo.is>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:33:25PM +0000, Ragnar B. Johannsson wrote:
> Move ieee80211_crypto*_init and _exit prototype declarations from r8192U_core.c to ieee80211/ieee80211.h. This fixes the following sparse warnings:
> 
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c:203:12: warning: symbol 'ieee80211_crypto_init' was not declared. Should it be static?
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c:223:13: warning: symbol 'ieee80211_crypto_deinit' was not declared. Should it be static?
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c:764:12: warning: symbol 'ieee80211_crypto_tkip_init' was not declared. Should it be static?
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c:769:13: warning: symbol 'ieee80211_crypto_tkip_exit' was not declared. Should it be static?
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c:467:12: warning: symbol 'ieee80211_crypto_ccmp_init' was not declared. Should it be static?
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c:472:13: warning: symbol 'ieee80211_crypto_ccmp_exit' was not declared. Should it be static?
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c:281:12: warning: symbol 'ieee80211_crypto_wep_init' was not declared. Should it be static?
> drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c:286:13: warning: symbol 'ieee80211_crypto_wep_exit' was not declared. Should it be static?
> 
> Signed-off-by: Ragnar B. Johannsson <ragnar@igo.is>
> ---
> Changes in v2: Remove extern, as suggested by Dan Carpenter.

Fantastic.  Thanks!

regards,
dan carpenter


