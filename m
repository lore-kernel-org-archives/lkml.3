Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaIWB5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:57:30 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:52929 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753470AbaIWB53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:57:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6120:7652:10004:10400:10848:11232:11657:11658:11914:12043:12291:12517:12519:12555:12683:12740:13069:13311:13357:13868:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: town00_41187ff22bc1b
X-Filterd-Recvd-Size: 2857
Message-ID: <1411437445.2952.61.camel@joe-AO725>
Subject: Re: [RFC PATCH linux-next] et131x: Promote staging et131x driver to
 drivers/net
From: Joe Perches <joe@perches.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@linuxfoundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Mon, 22 Sep 2014 18:57:25 -0700
In-Reply-To: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
References: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 22:28 +0100, Mark Einon wrote:
> This patch moves the et131x gigabit ethernet driver from drivers/staging
> to drivers/net/ethernet/agere.
> 
> There are no known issues at this time.

This doesn't apply to -next or -linux

[]
> This patch will only apply once the last few pending changes
> make their way from staging-next to linux-next, but posting
> now in the hope that feedback can be given and this change can
> make it in before the next merge window.n yo

When you do post the actual patch, can you please use
"git format-patch -M" so that the patch is significantly
smaller and the renames are obvious?

>  drivers/net/ethernet/Kconfig        |    1 +
>  drivers/net/ethernet/Makefile       |    1 +
>  drivers/net/ethernet/agere/Kconfig  |   31 +
>  drivers/net/ethernet/agere/Makefile |    5 +
>  drivers/net/ethernet/agere/et131x.c | 4412 +++++++++++++++++++++++++++++++++++
>  drivers/net/ethernet/agere/et131x.h | 1533 ++++++++++++
>  drivers/staging/Kconfig             |    2 -
>  drivers/staging/Makefile            |    1 -
>  drivers/staging/et131x/Kconfig      |   10 -
>  drivers/staging/et131x/Makefile     |    5 -
>  drivers/staging/et131x/README       |   15 -
>  drivers/staging/et131x/et131x.c     | 4412 -----------------------------------
>  drivers/staging/et131x/et131x.h     | 1533 ------------
>  13 files changed, 5983 insertions(+), 5978 deletions(-)
>  create mode 100644 drivers/net/ethernet/agere/Kconfig
>  create mode 100644 drivers/net/ethernet/agere/Makefile
>  create mode 100644 drivers/net/ethernet/agere/et131x.c
>  create mode 100644 drivers/net/ethernet/agere/et131x.h
>  delete mode 100644 drivers/staging/et131x/Kconfig
>  delete mode 100644 drivers/staging/et131x/Makefile
>  delete mode 100644 drivers/staging/et131x/README
>  delete mode 100644 drivers/staging/et131x/et131x.c
>  delete mode 100644 drivers/staging/et131x/et131x.h


