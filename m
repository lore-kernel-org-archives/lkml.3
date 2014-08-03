Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaHCQt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 12:49:26 -0400
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:42050 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750959AbaHCQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 12:49:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3871:3874:4321:5007:7652:9010:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: straw45_51fa31e7b5528
X-Filterd-Recvd-Size: 1225
Message-ID: <1407084561.12855.5.camel@joe-AO725>
Subject: Re: [PATCH] staging: rtl8192ee: checkpatch: use tabs for indent
From: Joe Perches <joe@perches.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        linux-kernel@vger.kernel.org
Date: Sun, 03 Aug 2014 09:49:21 -0700
In-Reply-To: <53DE6575.6070904@posteo.de>
References: <1407082009-17133-1-git-send-email-martink@posteo.de>
	 <1407083245.12855.3.camel@joe-AO725> <53DE6575.6070904@posteo.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-03 at 18:38 +0200, Martin Kepplinger wrote:
> I'd rather have the return value on the same line than aligned
> parameters but that's taste. Either way looks better and satisfies
> checkpatch, which is the only goal.

Satisfying checkpatch should not be high on the goal list.

Consistent readability should be though.

