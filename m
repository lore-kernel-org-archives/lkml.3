Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbARA4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:56:51 -0500
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:32858 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896AbbARA4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:56:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3870:3871:3872:4321:5007:7514:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12740:13019:13069:13311:13357:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shade26_58a07544ced5c
X-Filterd-Recvd-Size: 1766
Message-ID: <1421542606.29879.3.camel@perches.com>
Subject: Re: [PATCH] device: Fix dev_dbg_once macro
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Marc Finet <m.dreadlock@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 17 Jan 2015 16:56:46 -0800
In-Reply-To: <1420307493.15171.1.camel@perches.com>
References: <20150103110934.428f49af@mlap.lactee>
	 <1420307493.15171.1.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-03 at 09:51 -0800, Joe Perches wrote:
> There is a copy/paste typo in the dev_dbg_once macro.
> 
> It uses dev_info instead of dev_dbg, so use the correct
> function instead.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Noticed-by: Marc Finet <m.dreadlock@gmail.com>

Ping?

> ---
>  include/linux/device.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index fb50673..7b25323 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1156,7 +1156,7 @@ do {									\
>  #define dev_info_once(dev, fmt, ...)					\
>  	dev_level_once(dev_info, dev, fmt, ##__VA_ARGS__)
>  #define dev_dbg_once(dev, fmt, ...)					\
> -	dev_level_once(dev_info, dev, fmt, ##__VA_ARGS__)
> +	dev_level_once(dev_dbg, dev, fmt, ##__VA_ARGS__)
>  
>  #define dev_level_ratelimited(dev_level, dev, fmt, ...)			\
>  do {									\
> 



