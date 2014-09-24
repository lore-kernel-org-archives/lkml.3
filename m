Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaIXSlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:41:21 -0400
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:39104 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753219AbaIXSlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:41:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:965:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2903:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3872:3874:4041:4321:4390:4823:5007:6119:7652:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mine23_b0f1fc592d44
X-Filterd-Recvd-Size: 1909
Message-ID: <1411584074.3594.17.camel@joe-AO725>
Subject: checkpatch: Does anyone care that comments are freeform aligned?
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, tapaswenipathak@gmail.com,
        opw-kernel@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>
Date: Wed, 24 Sep 2014 11:41:14 -0700
In-Reply-To: <alpine.DEB.2.02.1409240745160.2051@localhost6.localdomain6>
References: <alpine.DEB.2.02.1409240745160.2051@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 07:47 +0200, Julia Lawall wrote:
> In the following patch extract, one line is indented with spaces rather 
> than tabs.  Is it intentional that checkpatch doesn't complain about this, 
> I guess due to the line being a comment?
[]
>  struct bcm_hdr_suppression_contextinfo {
> -	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
> -	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
> +    /* Intermediate buffer to accumulate pkt Header for PHS */
> +	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS];
> +	/* Intermediate buffer containing pkt Header after PHS */
> +	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN];
>  };

checkpatch does not care when comments start in any
particular position or ensure comments have tabs
preceding them.

Does anyone care?

