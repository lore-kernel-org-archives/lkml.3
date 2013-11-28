Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab3K1Scm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:32:42 -0500
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:59974 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755634Ab3K1Sci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:32:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7576:7652:8603:8985:9025:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tin55_50ead42ff3905
X-Filterd-Recvd-Size: 1482
Message-ID: <1385663555.12210.19.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf.c: add %paD format specifier for
 dma_addr_t types
From: Joe Perches <joe@perches.com>
To: "user.email" <andriy.shevchenko@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dmaengine@vger.kernel.org
Date: Thu, 28 Nov 2013 10:32:35 -0800
In-Reply-To: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1385638084-10719-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-28 at 13:28 +0200, user.email wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Add the %paD format specifier for printing a dma_addr_t type, since the
> DMA address size on some platforms can vary based on build options,
> regardless of the native integer type.

OK, but I prefer this one because upper case is
sometimes used to specify upper case only output.
ala %x %X and %pUl %pUL.

https://lkml.org/lkml/2013/9/12/483


