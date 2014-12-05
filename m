Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaLEPcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:32:43 -0500
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:51484 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750779AbaLEPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:32:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3870:3872:3873:3874:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jewel07_519d8d9930952
X-Filterd-Recvd-Size: 1085
Message-ID: <1417793559.2721.55.camel@perches.com>
Subject: Re: [PATCH] memstick: host: Fixed checkpatch warning
From: Joe Perches <joe@perches.com>
To: Athira Lekshmi <andnlnbn18@gmail.com>
Cc: rogerable@realtek.com, linux-kernel@vger.kernel.org, lee.jones@linaro.org
Date: Fri, 05 Dec 2014 07:32:39 -0800
In-Reply-To: <1417788087-8558-1-git-send-email-andnlnbn18@gmail.com>
References: <1417788087-8558-1-git-send-email-andnlnbn18@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 19:31 +0530, Athira Lekshmi wrote:
> Fixed the checkpatch warning:
> Missing a blank line after declarations

Please do not use checkpatch in the patch subject.

Describe what you are doing, not the tool that
prompted you to do it.


