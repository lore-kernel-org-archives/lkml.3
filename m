Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaLITOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:14:36 -0500
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:49968 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751362AbaLITOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:14:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1536:1559:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3874:4321:5007:6261:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tray33_44d7a3e0b0613
X-Filterd-Recvd-Size: 1139
Message-ID: <1418152471.15957.12.camel@perches.com>
Subject: Re: [PATCH 1/2] drivers/regulator/core.c: Don't print error on
 EPROBE_DEFER
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mike Looijmans <mike.looijmans@topic.nl>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Dec 2014 11:14:31 -0800
In-Reply-To: <20141209184817.GH11764@sirena.org.uk>
References: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
	 <20141209161420.GJ1934@sirena.org.uk> <54873B8E.1060106@topic.nl>
	 <20141209184817.GH11764@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 18:48 +0000, Mark Brown wrote:
> Can we do something with the log message that triggers on probe
> deferral?

Maybe add and use rdev_err_ratelimited?


