Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3JBGba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:31:30 -0400
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:48691 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753095Ab3JBGb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:31:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:69:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:3870:3872:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12683:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: songs35_46b19afe2cf01
X-Filterd-Recvd-Size: 1517
Message-ID: <1380695483.2081.30.camel@joe-AO722>
Subject: Re: [PATCH v3] Staging : android: binder.c: Prefer seq_puts to
 seq_printf
From: Joe Perches <joe@perches.com>
To: Mathieu =?ISO-8859-1?Q?Rh=E9aume?= <mathieu@codingrhemes.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, dan.carpenter@oracle.com,
        mirsal@mirsal.fr, serban.constantinescu@arm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 01 Oct 2013 23:31:23 -0700
In-Reply-To: <1380690159-17623-1-git-send-email-mathieu@codingrhemes.com>
References: <1380690159-17623-1-git-send-email-mathieu@codingrhemes.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 01:02 -0400, Mathieu Rhéaume wrote:
> Changes since v2:
>  * Fixed the indent in the method calls that had too many tab.
> 
> >8------------------------------------------------------8<
> 
> This patch changes seq_printf for seq_puts in binder.c.
> It fixes the warnings emitted by checkpatch.pl.

Please compile your patches before submitting them.

Checkpatch it pretty stupid and lots of these will
not compile correctly.

seq_puts takes only 2 arguments.

	seq_puts(seq, "string without %");


