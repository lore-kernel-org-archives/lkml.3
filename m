Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaAKRXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:23:50 -0500
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:37678 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752848AbaAKRXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:23:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3868:3870:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: room70_276127c34d46
X-Filterd-Recvd-Size: 1648
Message-ID: <1389461015.2537.55.camel@joe-AO722>
Subject: Re: [PATCH 1/2] Staging: lustre: Removal of Unnecessary white spaces
From: Joe Perches <joe@perches.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        peter.p.waskiewicz.jr@intel.com, tao.peng@emc.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 11 Jan 2014 09:23:35 -0800
In-Reply-To: <1389440466-6895-1-git-send-email-monamagarwal123@gmail.com>
References: <1389440466-6895-1-git-send-email-monamagarwal123@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-11 at 17:11 +0530, Monam Agarwal wrote:
> This fixes the following checkpatch.pl warning in
> lustre/ldlm/ldlm_extent.c
> WARNING: unnecessary whitespace before a quoted newline

I rather doubt this was the checkpatch message here.
Please make sure your commit message and subject match.

[]
> diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
[]
> @@ -153,7 +153,7 @@ static inline int lock_mode_to_index(ldlm_mode_t mode)
>  
>  	LASSERT(mode != 0);
>  	LASSERT(IS_PO2(mode));
> -	for (index = -1; mode; index++, mode >>= 1) ;
> +	for (index = -1; mode; index++, mode >>= 1);

Try using fls instead of this.


