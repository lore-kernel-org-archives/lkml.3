Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaETFKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:10:53 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:57003 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750731AbaETFKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:10:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3871:3873:4321:5007:7652:7901:7974:8531:9190:10004:10400:10466:10848:11658:11914:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hope55_5e9d1b37d3d1c
X-Filterd-Recvd-Size: 1316
Message-ID: <1400562648.22234.5.camel@joe-AO725>
Subject: Re: [PATCH V2 mmots] fs/hfsplus/wrapper.c: replace shift loop by fls
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 19 May 2014 22:10:48 -0700
In-Reply-To: <20140520070243.6fdb8ec2bbcc105fed0ae7ea@skynet.be>
References: <20140516223815.88ffae2289f969381f176fdc@skynet.be>
	 <20140519160946.84e79c832dfc4db0fbae573b@linux-foundation.org>
	 <1400541748.14238.58.camel@joe-AO725>
	 <20140519164037.ec6438686bd29efeebffa610@linux-foundation.org>
	 <1400543405.19786.4.camel@joe-AO725>
	 <20140520070243.6fdb8ec2bbcc105fed0ae7ea@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 07:02 +0200, Fabian Frederick wrote:
> and the winner is ? :)

Either works.  You're the patch submitter.  Pick one.

But I'm sure you know I'm not pushing the patch upstream... :)

