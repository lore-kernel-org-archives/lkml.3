Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbbAMF7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:59:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbbAMF7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:59:15 -0500
Date: Mon, 12 Jan 2015 19:37:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Krzysztof Adamski <k@japko.eu>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Use ether_addr_copy() in
 vnt_fill_ieee80211_rts.
Message-ID: <20150113033736.GC31093@kroah.com>
References: <20141216083021.GA14666@box2.japko.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216083021.GA14666@box2.japko.eu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 09:30:21AM +0100, Krzysztof Adamski wrote:
> Both struct ieee80211_rts and struct ieee80211_hdr defined in
> linux/ieee80211.h are declared as __aligned(2) so it is safe to use
> ether_addr_copy() instead of memcpy().
> 
> Signed-off-by: Krzysztof Adamski <k@japko.eu>
> ---
>   drivers/staging/vt6656/rxtx.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
> index ea5140a..280c923 100644
> --- a/drivers/staging/vt6656/rxtx.c
> +++ b/drivers/staging/vt6656/rxtx.c
> @@ -36,6 +36,7 @@
>    *
>    */
>   
> +#include <linux/etherdevice.h>
>   #include "device.h"
>   #include "rxtx.h"
>   #include "card.h"

Something corrupted this patch :(

