Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3ISSbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:31:20 -0400
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:51608 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751894Ab3ISSbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:31:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6119:7652:7875:10004:10400:10848:11232:11658:11914:12043:12050:12114:12295:12517:12519:12555:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: earth03_453c4b3e24f45
X-Filterd-Recvd-Size: 2647
Message-ID: <1379615474.22168.13.camel@joe-AO722>
Subject: [PATCH] stable_kernel_rules.txt: Exclude networking from stable
 rules
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: stephen@networkplumber.org, netdev@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 19 Sep 2013 11:31:14 -0700
In-Reply-To: <alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1309191229480.32035@file01.intranet.prod.int.rdu2.redhat.com>
	 <20130919.135628.1201613770803318193.davem@davemloft.net>
	 <alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Networking is once again "special", so at least document
how it's working today in the hope that doing so makes
less work for all that actually read the documentation.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Thu, 19 Sep 2013, David Miller wrote:
> Secondly, CC:'ing stable is not the correct way to submit networking
> patches for -stable inclusion.  You simply ask me to queue them up
> for -stable explicitly instead.

 Documentation/stable_kernel_rules.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index b0714d8..a2d6da0 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -29,6 +29,11 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 
 Procedure for submitting patches to the -stable tree:
 
+ - The networking tree (net/ and drivers/net/) is 'special' and doesn't
+   follow the rules below.  Don't send or cc: patches for the -stable tree to
+   stable@vger.kernel.org.  Don't mark them stable.  Just send the patches to
+   netdev@vger.kernel.org and let the networking maintainer decide what to do
+   with them.
  - Send the patch, after verifying that it follows the above rules, to
    stable@vger.kernel.org.  You must note the upstream commit ID in the
    changelog of your submission, as well as the kernel version you wish



