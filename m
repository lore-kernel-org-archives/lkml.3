Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaAEUbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 15:31:03 -0500
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:42984 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751405AbaAEUaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:30:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3870:4321:5007:7652:8957:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: seat34_7c0d3cc35271e
X-Filterd-Recvd-Size: 1630
Message-ID: <1388953851.5808.31.camel@joe-AO722>
Subject: Re: [PATCH 1/2] Staging: lustre: Fix line length exceeding 80
 characters
From: Joe Perches <joe@perches.com>
To: MonamAgarwal <monamagarwal123@gmail.com>
Cc: gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 05 Jan 2014 12:30:51 -0800
In-Reply-To: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
References: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 01:41 +0530, MonamAgarwal wrote:
> This patch fixes the following checkpatch.pl warning in
> lustre/ldlm/interval_tree.c
> WARNING: line over 80 characters in the file
[]
> diff --git a/drivers/staging/lustre/lustre/ldlm/interval_tree.c b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
[]
> @@ -429,7 +429,8 @@ static void interval_erase_color(struct interval_node *node,
>  					struct interval_node *o_left;
>  					o_left = tmp->in_left;
>  					if (o_left)
> -						o_left->in_color = INTERVAL_BLACK;
> +						o_left->in_color =
> +							INTERVAL_BLACK;

Likely this function would be better off with some
refactoring instead of straining to fit 80 cols.


