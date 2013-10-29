Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3J2SUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:20:49 -0400
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:46463 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755593Ab3J2SUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:20:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3622:3870:3876:4321:5007:6119:6120:7652:7809:7901:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chess07_7ad971dd37210
X-Filterd-Recvd-Size: 1595
Message-ID: <1383070843.12439.14.camel@joe-AO722>
Subject: Re: [PATCH 2/2] MAINTAINERS: add Intel MID SSP SPI maintainers
From: Joe Perches <joe@perches.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: broonie@kernel.org, ning.li@intel.com, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Date: Tue, 29 Oct 2013 11:20:43 -0700
In-Reply-To: <1383069950-27754-2-git-send-email-david.a.cohen@linux.intel.com>
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
	 <1383069950-27754-2-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 11:05 -0700, David Cohen wrote:
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -1916,6 +1916,14 @@ L:	linux-gpio@vger.kernel.org
>  S:	Maintained
>  F:	drivers/gpio/gpio-intel-mid.c

Please insert this section in alphabetic order.
 
> +INTEL-MID SSP SPI DRIVER
> +M:	Ning Li <ning.li@intel.com>
> +M:	David Cohen <david.a.cohen@linux.intel.com>
> +L:	linux-spi@vger.kernel.org
> +S:	Maintained

Supported?

> +F:	drivers/spi/spi-intel-mid-ssp.c
> +F:	include/linux/spi/intel_mid_ssp_spi.h
> +
>  BTRFS FILE SYSTEM
>  M:	Chris Mason <chris.mason@fusionio.com>
>  L:	linux-btrfs@vger.kernel.org



