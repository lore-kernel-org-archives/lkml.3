Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaLQJ1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:27:20 -0500
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:51191 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750829AbaLQJ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:27:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:4321:5007:6261:6691:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bath29_3f868fdb1c020
X-Filterd-Recvd-Size: 1291
Message-ID: <1418808435.14140.16.camel@perches.com>
Subject: Re: [PATCH] checkpatch: enable MAINTAINERS warning only for
 --strict,--subjective
From: Joe Perches <joe@perches.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, Kevin Cernekee <cernekee@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 17 Dec 2014 01:27:15 -0800
In-Reply-To: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
References: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 23:35 -0800, Brian Norris wrote:
> The rule which delivers this warning is very prone to errors:
>   "added, moved or deleted file(s), does MAINTAINERS need updating?"
> so it should not be enabled by default.

I don't think so.

It's _far_ more common for people to forget to
update MAINTAINERS so I think it's quite useful
even if it's slightly noisy.

