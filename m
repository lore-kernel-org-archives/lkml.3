Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaCRDTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 23:19:23 -0400
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:33208 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751706AbaCRDTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 23:19:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:4321:5007:6642:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13160:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: event39_6e3b689af273e
X-Filterd-Recvd-Size: 1283
Message-ID: <1395112756.20860.1.camel@joe-AO722>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
From: Joe Perches <joe@perches.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Date: Mon, 17 Mar 2014 20:19:16 -0700
In-Reply-To: <20140318002822.372705594@telegraphics.com.au>
References: <20140318002822.372705594@telegraphics.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 11:28 +1100, Finn Thain wrote:
> This patch series addresses several issues with NCR5380 drivers:
[]
> 3. Broken debugging code.

My preference would be to change dprintk to scsi_dbg

Seems sensible otherwise.

