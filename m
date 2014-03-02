Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaCBPkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:40:31 -0500
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:56031 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614AbaCBPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:40:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:4321:5007:7652:10004:10400:10471:10848:11232:11658:11914:12517:12519:12740:13069:13095:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dock56_787658f4bed5e
X-Filterd-Recvd-Size: 1277
Message-ID: <1393774826.13719.31.camel@joe-AO722>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: to give more detailed
 warning message in case printk is used in any patch
From: Joe Perches <joe@perches.com>
To: Levente Kurusa <levex@linux.com>
Cc: Yogesh Chaudhari <mr.yogesh@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, apw@canonical.com
Date: Sun, 02 Mar 2014 07:40:26 -0800
In-Reply-To: <53134C4D.2090406@linux.com>
References: <CAAOfnZp-KAFo8Q4bBW7oxe8BgUn+bSDAWuHbK6E+SF0X0Ex=Wg@mail.gmail.com>
	 <53134C4D.2090406@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-02 at 16:20 +0100, Levente Kurusa wrote:
> IMHO, this message is too big. The one we already have is nice and clean.
> I would simply do: s/netdev/[subsystem]/ or something among the lines.

maybe:

"Prefer [subsystem eg: netdev]_$level2 then dev_$level2 then pr_$level to printk(KERN_$orig ...\n"

or reference the stackoverflow link

