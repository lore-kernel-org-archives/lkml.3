Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaKJUyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:54:25 -0500
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:43955 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751452AbaKJUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:54:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2890:3138:3139:3140:3141:3142:3622:3866:3867:3868:3873:4042:4321:5007:6261:10004:10400:10848:11232:11658:11914:12109:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: noise15_7d98b292da629
X-Filterd-Recvd-Size: 1181
Message-ID: <1415652861.8868.19.camel@perches.com>
Subject: Re: [PATCH v2 00/10 linux-next] cdrom: sysctl export + clean-up
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Mon, 10 Nov 2014 12:54:21 -0800
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 21:21 +0100, Fabian Frederick wrote:
> This patchset moves sysctl functions to a new file cdrom_sysctl.c
> and tries to solve small code / coding style issues.

Hey Fabian.

You're doing a lot of these.

Maybe you should setup a git tree somewhere
(maybe repo.or.cz or request a kernel.org account)
and let people pull your branches from there.


