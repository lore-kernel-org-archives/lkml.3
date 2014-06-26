Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbaFZCHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:07:30 -0400
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:44837 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755519AbaFZCH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:07:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3868:3870:3871:3873:4321:4605:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12043:12214:12438:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sign92_40d10c7b5a911
X-Filterd-Recvd-Size: 2127
Message-ID: <1403748444.7977.2.camel@joe-AO725>
Subject: Re: [PATCH] staging: wlan-ng/hfa384x_usb.c: add blank line after
 declarations
From: Joe Perches <joe@perches.com>
To: Cheng-Wei Lee <lee.rhapsody@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jun 2014 19:07:24 -0700
In-Reply-To: <CAJKoSVSBBawWBzOmQixTf+DZpWLk1YyNao2-5ESM1-VdTWnFpg@mail.gmail.com>
References: <CAJKoSVSBBawWBzOmQixTf+DZpWLk1YyNao2-5ESM1-VdTWnFpg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 09:55 +0800, Cheng-Wei Lee wrote:
> This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
> WARNING: Missing a blank line after declarations

This time you've got the right subject, and right type of content,
but unfortunately, the content is wrapped and can't be applied.

Please read Documentation/email-clients.txt
and resubmit.

> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
> b/drivers/staging/wlan-ng/hfa384x_usb.c
> index 98343ff7..07cee56 100644
> --- a/drivers/staging/wlan-ng/hfa384x_usb.c
> +++ b/drivers/staging/wlan-ng/hfa384x_usb.c
> @@ -3705,6 +3705,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
>                 case -EPIPE:
>                         {
>                                 hfa384x_t *hw = wlandev->priv;
> +
>                                 netdev_warn(hw->wlandev->netdev,
>                                             "%s tx pipe stalled:
> requesting reset\n",
>                                             wlandev->netdev->name);
> --


