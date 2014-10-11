Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaJKPgi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 11:36:38 -0400
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:48571 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752302AbaJKPgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 11:36:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3871:3873:4250:4321:5007:6119:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: play61_73b35dbef9449
X-Filterd-Recvd-Size: 1584
Message-ID: <1413041793.16385.22.camel@joe-AO725>
Subject: Re: [PATCH] usb: serial: Fix indentation style issue
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Philip Munksgaard <pmunksgaard@gmail.com>, johan@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 11 Oct 2014 08:36:33 -0700
In-Reply-To: <20141011142049.GA11456@kroah.com>
References: <1413035383-3981-1-git-send-email-pmunksgaard@gmail.com>
	 <20141011142049.GA11456@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 07:20 -0700, Greg KH wrote:
> On Sat, Oct 11, 2014 at 03:49:43PM +0200, Philip Munksgaard wrote:
> > Fix a style issue
[]
> > diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
[]
> > @@ -1616,7 +1616,7 @@ static const struct usb_device_id option_ids[] = {
> >  	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
> >  	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
> >    	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
> > -  	},
> > +	},
> 
> Why not fix the same 'space' issue on the line before this at the same
> time?

I think there is no space issue on the previous line.
What do you see Greg?



