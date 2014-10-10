Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaJJPDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:03:14 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:38389 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753917AbaJJPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:03:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:3871:4321:5007:7514:7652:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: north52_388d73cc80100
X-Filterd-Recvd-Size: 1561
Message-ID: <1412953387.8770.23.camel@joe-AO725>
Subject: Re: [PATCH 1/1] Checkpatch: coding style errors in Nvidia ethernet
 driver
From: Joe Perches <joe@perches.com>
To: Akshay Sarode <akshaysarode21@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 10 Oct 2014 08:03:07 -0700
In-Reply-To: <1412928102-1696-1-git-send-email-akshaysarode21@gmail.com>
References: <1412928102-1696-1-git-send-email-akshaysarode21@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 13:31 +0530, Akshay Sarode wrote:
> ERROR: "foo* bar" should be "foo *bar"
> ERROR: do not initialise statics to 0 or NULL
> CHECK: spinlock_t definition without comment
> Signed-off-by: Akshay Sarode <akshaysarode21@gmail.com>
[]
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
[]
> @@ -911,12 +913,18 @@ enum {
[]
>  /*
>   * Debug output control for tx_timeout
>   */
> -static bool debug_tx_timeout = false;
> +enum {
> +	NV_DEBUG_TX_TIMEOUT_DISABLED,
> +	NV_DEBUG_TX_TIMEOUT_ENABLED
> +};
> +
> +static bool debug_tx_timeout = NV_DEBUG_TX_TIMEOUT_DISABLED;

Adding this enum is not useful.

