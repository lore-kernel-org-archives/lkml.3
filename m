Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaLRVR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:17:58 -0500
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:49865 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751235AbaLRVR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:17:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:3873:3874:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: joke01_451307054ba17
X-Filterd-Recvd-Size: 1438
Message-ID: <1418937472.28384.14.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Fix MAINTAINERS search pattern
From: Joe Perches <joe@perches.com>
To: Derek Chickles <dchickles@caviumnetworks.com>
Cc: apw@canonical.com, computersforpeace@gmail.com,
        linux-kernel@vger.kernel.org, cernekee@gmail.com,
        Derek Chickles <derek.chickles@caviumnetworks.com>
Date: Thu, 18 Dec 2014 13:17:52 -0800
In-Reply-To: <1418933533-8364-1-git-send-email-dchickles@caviumnetworks.com>
References: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
	 <1418933533-8364-1-git-send-email-dchickles@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-18 at 12:12 -0800, Derek Chickles wrote:
> This fixes the check that was supposed to prevent the MAINTAINERS
> warning from appearing when you run checkpatch.pl on a patch that
> includes new files/directories and an updated MAINTAINERS file.

This suggested patch doesn't work.

$realfile isn't set until the file shows up
in the patch itself.

The current test looks at the changelog
before the files are modified and is correct.


