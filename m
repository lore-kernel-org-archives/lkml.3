Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbbACSCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 13:02:10 -0500
Received: from senator.holtmann.net ([87.106.208.187]:48555 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbbACSCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 13:02:07 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1420297188.2397.3.camel@tiscali.nl>
Date: Sat, 3 Jan 2015 10:02:00 -0800
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CD467A59-F563-439B-BA82-954AB27AD9CC@holtmann.org>
References: <1420297188.2397.3.camel@tiscali.nl>
To: Paul Bolle <pebolle@tiscali.nl>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> This reverts commit dddd60220f41775e634258efd1b54c6fa81ce706.
> 
> The raison d'être of commit dddd60220f41 ("ipw2200: select
> CFG80211_WEXT") was reverted in commit 2d36e008739e ("Revert "cfg80211:
> make WEXT compatibility unselectable""). So revert this commit too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> drivers/net/wireless/ipw2x00/Kconfig | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
> index 21de4fe6cf2d..91c0cb3c368e 100644
> --- a/drivers/net/wireless/ipw2x00/Kconfig
> +++ b/drivers/net/wireless/ipw2x00/Kconfig
> @@ -65,8 +65,7 @@ config IPW2100_DEBUG
> 
> config IPW2200
> 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
> -	depends on PCI && CFG80211
> -	select CFG80211_WEXT
> +	depends on PCI && CFG80211 && CFG80211_WEXT
> 	select WIRELESS_EXT
> 	select WEXT_SPY
> 	select WEXT_PRIV

why would you revert this? It is obviously the correct change to actually select CFG80211_WEXT.

Regards

Marcel

