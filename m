Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbaLDVdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:33:05 -0500
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:54003 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932094AbaLDVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:33:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3866:3872:4321:5007:6119:6120:6261:7901:8603:10004:10400:10848:11658:11914:12517:12519:12555:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: note81_71b365df73131
X-Filterd-Recvd-Size: 1028
Message-ID: <1417728779.2721.15.camel@perches.com>
Subject: tinyconfig x86-32 vmlinux sizes by gcc compiler version
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 04 Dec 2014 13:32:59 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just fyi.

At least for x86-32, it seems later versions of gcc
are producing smaller images.

$ size vmlinux.*
   text	   data	    bss	    dec	    hex	filename
 657725	 118496	1189040	1965261	 1dfccd	vmlinux.4.4
 633563	 118528	1189448	1941539	 1da023	vmlinux.4.6
 633277	 118496	1189592	1941365	 1d9f75	vmlinux.4.7
 632299	 121120	1192784	1946203	 1db25b	vmlinux.4.9


