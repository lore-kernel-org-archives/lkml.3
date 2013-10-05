Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3JESEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 14:04:09 -0400
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:59883 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751525Ab3JESEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 14:04:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:4321:5007:6642:7652:7875:10004:10400:10848:11026:11473:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sand67_23abfdadbdc1a
X-Filterd-Recvd-Size: 1474
Message-ID: <1380996244.2081.125.camel@joe-AO722>
Subject: Re: [PATCH 2/5] drivers: usb: core: hcd: Whitespace fixes
From: Joe Perches <joe@perches.com>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 05 Oct 2013 11:04:04 -0700
In-Reply-To: <e5dba9e89cd8c98d7d2f2578b72482ccf0a4ea88.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
	 <e5dba9e89cd8c98d7d2f2578b72482ccf0a4ea88.1380986962.git.mail@beyermatthias.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-05 at 18:02 +0200, Matthias Beyer wrote:
> - removing spaces before array indexing (foo [] to foo[])
[]
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
[]
> @@ -93,7 +93,7 @@ EXPORT_SYMBOL_GPL (usb_bus_list);
>  /* used when allocating bus numbers */
>  #define USB_MAXBUS		64
>  struct usb_busmap {
> -	unsigned long busmap [USB_MAXBUS / (8*sizeof (unsigned long))];
> +	unsigned long busmap[USB_MAXBUS / (8*sizeof (unsigned long))];

this would be nicer as

	DEFINE_BITMAP(busmap, USB_MAXBUS);


