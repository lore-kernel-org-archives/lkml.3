Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3KHDYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 22:24:33 -0500
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:34775 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756247Ab3KHDYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 22:24:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4250:4321:5007:7652:8957:10004:10400:10848:11232:11473:11658:11914:12517:12519:12740:13069:13141:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grass32_9e73b4ea992d
X-Filterd-Recvd-Size: 1742
Message-ID: <1383881076.9263.64.camel@joe-AO722>
Subject: Re: PATCH] LEDS: tca6507 - fix up some comments.
From: Joe Perches <joe@perches.com>
To: NeilBrown <neilb@suse.de>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Date: Thu, 07 Nov 2013 19:24:36 -0800
In-Reply-To: <20131108142004.10e31655@notabene.brown>
References: <20131101134120.13a44225@notabene.brown>
	 <CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
	 <20131108142004.10e31655@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 14:20 +1100, NeilBrown wrote:
> In particular fix the capitalisation of GPIO and LED and
> correct TCA6507_MAKE_CPIO, but also rewrite the comment about
> platform-data to include reference to devicetree.

trivia:

> diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
[]
> @@ -8,7 +8,7 @@
>   * double-blink.
>   *
>   * This driver can configure each line either as a 'GPIO' which is out-only
> - * (no pull-up) or as an LED with variable brightness and hardware-assisted
> + * (pull-up resistor required) or as an LED with variable brightness and hardware-assisted
>   * blinking.

Please rewrap the comment to 80 cols.


