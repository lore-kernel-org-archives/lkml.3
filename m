Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaFFFeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:34:11 -0400
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:53916 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750803AbaFFFeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:34:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3871:3876:4321:5007:7514:7576:7652:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: star17_7b3a909ee8d2d
X-Filterd-Recvd-Size: 1496
Message-ID: <1402032845.3038.6.camel@joe-AO725>
Subject: Re: [PATCH 1/1] Staging:tidspbridge Fix minor checkpatch.pl warning
From: Joe Perches <joe@perches.com>
To: Adithya <linux.challenge1@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        ody.guru@gmail.com, dan.carpenter@oracle.com, freemangordon@abv.bg,
        rashika.kheria@gmail.com, gregkh@linuxfoundation.org,
        omar.ramirez@copitl.com
Date: Thu, 05 Jun 2014 22:34:05 -0700
In-Reply-To: <5391497D.8040800@gmail.com>
References: <5391497D.8040800@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 10:24 +0530, Adithya wrote:
> From: Adithya K<linux.challenge1@gmail.com>
> 
> Fixed checkpatch "WARNING: Missing a blank line after declarations"
[]
> diff --git a/drivers/staging/tidspbridge/gen/gh.c b/drivers/staging/tidspbridge/gen/gh.c
[]
> @@ -28,6 +28,7 @@ struct gh_node {
>   struct gh_t_hash_tab {
>   	u32 val_size;
>   	DECLARE_HASHTABLE(hash_table, GH_HASH_ORDER);
> +
>   	u32 (*hash)(const void *key);
>   	bool (*match)(const void *key, const void *value);
>   	void (*delete)(void *key);

this one is a checkpatch defect.


