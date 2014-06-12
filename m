Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbaFLRzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:55:21 -0400
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:59264 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750911AbaFLRzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:55:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3870:3872:3873:4321:5007:7514:7652:7903:9545:10004:10400:10848:11026:11232:11658:11914:12114:12517:12519:12679:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bean28_6835bee10cb0d
X-Filterd-Recvd-Size: 1799
Message-ID: <1402595714.12385.13.camel@joe-AO725>
Subject: Re: [PATCH v2 1/2]
 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c: fix coding style
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wahib Faizi <wahibfaizi@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 10:55:14 -0700
In-Reply-To: <20140612175400.GA30060@kroah.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
	 <1402594340-10867-1-git-send-email-wahibfaizi@gmail.com>
	 <1402594340-10867-2-git-send-email-wahibfaizi@gmail.com>
	 <20140612175400.GA30060@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 10:54 -0700, Greg Kroah-Hartman wrote:
> On Thu, Jun 12, 2014 at 09:32:19PM +0400, Wahib Faizi wrote:
> > Fix coding style issue "do not use assignment in if condition"
> > detected by checkpatch.pl in usbip_host_driver.c.
> > 
> > Signed-off-by: Wahib Faizi <wahibfaizi@gmail.com>
> 
> Both of these patches have the same Subject: line, which isn't good as
> it doesn't make much sense.
> 
> You can also shorten it a lot, for example, this one should be:
>   Subject: staging: usbip: usbip_host_driver.c: fix if assignment style issue

True.  usbip_host_driver.c doesn't add much though.

It could even be something like:

staging: usbip: avoid assignment in if


