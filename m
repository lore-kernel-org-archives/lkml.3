Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaFYP2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:28:51 -0400
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:32922 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756515AbaFYP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:28:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3870:4321:5007:7514:7652:7903:10004:10400:10848:11232:11658:11914:12043:12438:12517:12519:12555:12740:13019:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toe89_11ca234ebb717
X-Filterd-Recvd-Size: 1978
Message-ID: <1403710120.22753.15.camel@joe-AO725>
Subject: Re: [PATCH 1/2] staging: wlan-ng/hfa384x_usb.c: remove return
 statements for void function
From: Joe Perches <joe@perches.com>
To: Cheng-Wei Lee <lee.rhapsody@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 08:28:40 -0700
In-Reply-To: <CAJKoSVTGC+-v09aCDTV5HfnpDMVuPiGTe5-Y9TMu+2E+EzMotw@mail.gmail.com>
References: <CAJKoSVTGC+-v09aCDTV5HfnpDMVuPiGTe5-Y9TMu+2E+EzMotw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 23:24 +0800, Cheng-Wei Lee wrote:
> This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
> WARNING: void function return statements are not generally useful

subject/code mismatch.

> Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
> ---
>  drivers/staging/wlan-ng/hfa384x_usb.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
> b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 98343ff7..07cee56 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
> @@ -3705,6 +3705,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
>  		case -EPIPE:
>  			{
>  				hfa384x_t *hw = wlandev->priv;
> +
>  				netdev_warn(hw->wlandev->netdev,
>  					    "%s tx pipe stalled: requesting reset\n",
>  					    wlandev->netdev->name);



