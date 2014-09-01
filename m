Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaIARWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:22:51 -0400
Received: from smtprelay0128.hostedemail.com ([216.40.44.128]:59655 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751998AbaIARWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:22:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3868:3870:3871:3872:4250:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12043:12050:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: train05_188805e18af2b
X-Filterd-Recvd-Size: 1900
Message-ID: <1409592167.2614.7.camel@joe-AO725>
Subject: Re: [PATCH] staging: xillybus: Move out of staging
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eli Billauer <eli.billauer@gmail.com>, gregkh@linuxfoundation.org,
        arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Sep 2014 10:22:47 -0700
In-Reply-To: <20140901121318.GG5122@mwanda>
References: <1409471821-11809-1-git-send-email-eli.billauer@gmail.com>
	 <20140901121318.GG5122@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 15:13 +0300, Dan Carpenter wrote:
> Pretty nice.  This is very special purpose hardware and the UAPI for
> this is fine.  The documentation seems good.  I had some minor style
> comments but nothing major stands out.
> 
> These days I quite like the --strict option for checkpatch.pl.
> 
> for i in $(find drivers/staging/xillybus/ -name \*\.c)
> 	do ./scripts/checkpatch.pl --strict -f $i
> done

Maybe --strict should be on by default for staging
like it is for drivers/net and net?
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d89857d..90199a7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2016,7 +2016,7 @@ sub process {
 		}
 
 		if ($found_file) {
-			if ($realfile =~ m@^(drivers/net/|net/)@) {
+			if ($realfile =~ m@^(drivers/net/|net/|drivers/staging/)@) {
 				$check = 1;
 			} else {
 				$check = $check_orig;


