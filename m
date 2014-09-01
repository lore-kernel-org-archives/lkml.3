Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaIAQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:26:24 -0400
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:55858 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753963AbaIAQ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:26:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3872:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12517:12519:12740:13069:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tray94_71ae904313a16
X-Filterd-Recvd-Size: 1802
Message-ID: <1409588779.2614.2.camel@joe-AO725>
Subject: Re: [PATCH] staging: lustre: lov_pack: fix coding style issue
From: Joe Perches <joe@perches.com>
To: sunwxg <sun.wxg@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Chi Pham <fempsci@gmail.com>, Oleg Drokin <green@linuxhacker.ru>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Sep 2014 09:26:19 -0700
In-Reply-To: <1409586755-805-2-git-send-email-sun.wxg@gmail.com>
References: <1409586755-805-2-git-send-email-sun.wxg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 23:52 +0800, sunwxg wrote:
> Fix the style error checking by checkpatch.pl
> ERROR: space required after that ','
[]
> diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
[]
> @@ -95,7 +95,7 @@ void lov_dump_lmm_v1(int level, struct lov_mds_md_v1 *lmm)
>  void lov_dump_lmm_v3(int level, struct lov_mds_md_v3 *lmm)
>  {
>  	lov_dump_lmm_common(level, lmm);
> -	CDEBUG(level,"pool_name "LOV_POOLNAMEF"\n", lmm->lmm_pool_name);
> +	CDEBUG(level, "pool_name "LOV_POOLNAMEF"\n", lmm->lmm_pool_name);

I think it better to separate the pre-coalesced
bits of the string like:

	"pool name " LOV_POOLNAMEF "\n",


