Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaCBMTC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 07:19:02 -0500
Received: from smtprelay0172.hostedemail.com ([216.40.44.172]:33884 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752251AbaCBMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 07:18:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3870:3871:3873:3874:4321:5007:7652:8527:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12663:12740:13069:13071:13095:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nut51_6b53b647e3748
X-Filterd-Recvd-Size: 1374
Message-ID: <1393762736.13719.19.camel@joe-AO722>
Subject: Re: scripts/checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Yogesh Chaudhari <mr.yogesh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sun, 02 Mar 2014 04:18:56 -0800
In-Reply-To: <CAAOfnZrRGd0Bdg0c0D1015O5f=BC2=hwfZ5WNv=z5bBf5y6TmQ@mail.gmail.com>
References: <CAAOfnZrRGd0Bdg0c0D1015O5f=BC2=hwfZ5WNv=z5bBf5y6TmQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-02 at 14:13 +0530, Yogesh Chaudhari wrote:
> I think the [checkpatch] WARNING message should be
> modified to mention that [subsystem]_dbg is preferred over dev_dbg. In
> case this is correct and I am not missing something, I would like to
> propose a patch to modify this script to give appropriate error
> message. But in case I am wrong about this I would like
> comments/suggestions/explanations before starting anything.

Hi Yogesh.

Phrasing is hard.
Whatever, knock yourself out.
Propose a patch.

cc the checkpatch maintainers when you do.

cheers, Joe

