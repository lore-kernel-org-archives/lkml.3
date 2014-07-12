Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaGLCJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:09:37 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:33105 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754499AbaGLCJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:09:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3872:3874:4250:4321:4362:4823:5007:7652:8604:9393:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13095:13161:13221:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tree98_8d7b608c5fa0c
X-Filterd-Recvd-Size: 1988
Message-ID: <1405130970.6751.37.camel@joe-AO725>
Subject: [PATCH] checkpatch: Remove unnecessary + after {8,8}
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 11 Jul 2014 19:09:30 -0700
In-Reply-To: <20140712020520.GA18611@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
	 <20140712013927.GA30781@kroah.com> <1405129612.6751.24.camel@joe-AO725>
	 <20140712020114.GA12301@kroah.com> <20140712020520.GA18611@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a useless "+" use that needs to be removed as perl 5.20
emits a "Useless use of greediness modifier '+'" message each
time it's hit.

Reported-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
On Fri, 2014-07-11 at 19:05 -0700, Greg KH wrote:
> Ok, with linux-next I get the same thing:

Thanks Greg.

 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d5ac001..370a974 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2376,7 +2376,7 @@ sub process {
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
 				while ($fixed[$fixlinenr] =~
-					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
+					   s/(^\+.*) {8,8}\t/$1\t\t/) {}
 				while ($fixed[$fixlinenr] =~
 					   s/(^\+.*) +\t/$1\t/) {}
 			}


