Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaETT07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:26:59 -0400
Received: from smtprelay0068.hostedemail.com ([216.40.44.68]:45938 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750766AbaETT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:26:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:3872:3873:3874:4321:5007:7652:7875:9121:10004:10400:10848:11232:11658:11914:12043:12262:12438:12517:12519:12555:12679:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rifle18_22fbfb016d4a
X-Filterd-Recvd-Size: 2064
Message-ID: <1400614013.26709.29.camel@joe-AO725>
Subject: Re: [PATCH 4/5] appledisplay: Convert /n to \n
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 12:26:53 -0700
In-Reply-To: <9bbe7dc36e6b609512f166e10b6b99a706fbbd11.1398390579.git.joe@perches.com>
References: <cover.1398390579.git.joe@perches.com>
	 <9bbe7dc36e6b609512f166e10b6b99a706fbbd11.1398390579.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 18:51 -0700, Joe Perches wrote:
> Use a newline character appropriately.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Greg?  Ping?

You inadvertently added this "/n" use in
commit 0a3fd536e685e0ceb646de1a43821bd11c0be75c
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue May 1 21:33:54 2012 -0700

    USB: appledisplay.c: remove dbg() usage
    
    dbg() was a very old USB-specific macro that should no longer
    be used. This patch removes it from being used in the driver
    and uses dev_dbg() instead.

>  drivers/usb/misc/appledisplay.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
> index ba6a5d6..f37c78d 100644
> --- a/drivers/usb/misc/appledisplay.c
> +++ b/drivers/usb/misc/appledisplay.c
> @@ -110,7 +110,7 @@ static void appledisplay_complete(struct urb *urb)
>  			__func__, status);
>  		return;
>  	default:
> -		dev_dbg(dev, "%s - nonzero urb status received: %d/n",
> +		dev_dbg(dev, "%s - nonzero urb status received: %d\n",
>  			__func__, status);
>  		goto exit;
>  	}



