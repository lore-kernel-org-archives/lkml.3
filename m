Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbbAMRM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:12:26 -0500
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:41186 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752703AbbAMRMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:12:24 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:4250:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grade15_1496a83296f19
X-Filterd-Recvd-Size: 1183
Message-ID: <1421169139.9233.24.camel@perches.com>
Subject: Re: [PATCH] Staging: vt6656: Checkpatch fix: else after break or
 return
From: Joe Perches <joe@perches.com>
To: Emrys Bayliss <emrys@paradise.net.nz>
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Jan 2015 09:12:19 -0800
In-Reply-To: <1421168604-29857-1-git-send-email-emrys@paradise.net.nz>
References: <1421168604-29857-1-git-send-email-emrys@paradise.net.nz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-14 at 04:03 +1100, Emrys Bayliss wrote:
> This patch fixes the following checkpatch.pl error:
> rxtx.c:558: WARNING: else is not generally useful after a break or return

"not generally" does not mean always.

It's OK to ignore these messages too.


