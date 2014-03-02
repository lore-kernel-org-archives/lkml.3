Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaCBSyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 13:54:55 -0500
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:53400 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751720AbaCBSyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 13:54:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:4321:5007:7652:8957:10004:10400:10471:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drink44_47676d20ee65b
X-Filterd-Recvd-Size: 1404
Message-ID: <1393786489.13719.32.camel@joe-AO722>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: to give more detailed
 warning message in case printk is used in any patch
From: Joe Perches <joe@perches.com>
To: Yogesh Chaudhari <mr.yogesh@gmail.com>
Cc: Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Robo Bot <apw@canonical.com>
Date: Sun, 02 Mar 2014 10:54:49 -0800
In-Reply-To: <CAAOfnZpW7GLb2dUfGGe7ET7QXQuNvVsjGcz_RkNy00omoM_8sw@mail.gmail.com>
References: <CAAOfnZp-KAFo8Q4bBW7oxe8BgUn+bSDAWuHbK6E+SF0X0Ex=Wg@mail.gmail.com>
	 <53134C4D.2090406@linux.com> <1393774826.13719.31.camel@joe-AO722>
	 <CAAsK9AEWRD+n=bjAsJ-oRJsc+UQJ_LC+F9Psc+cCcK2rLzYsPw@mail.gmail.com>
	 <CAAOfnZpW7GLb2dUfGGe7ET7QXQuNvVsjGcz_RkNy00omoM_8sw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-02 at 21:51 +0530, Yogesh Chaudhari wrote:
> I will send in a new patch with both the script file and the
> documentation modifications.

Separate patches please.
Changes to CodingStyle generally bring another
round of comments.


