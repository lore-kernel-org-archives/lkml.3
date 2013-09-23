Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3IWA3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 20:29:36 -0400
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:33426 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752219Ab3IWA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 20:29:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3868:3873:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache
X-HE-Tag: work16_18ebd2b832746
X-Filterd-Recvd-Size: 1388
Message-ID: <1379896169.3575.1.camel@joe-AO722>
Subject: Re: [PATCH 1/5] scsi: Fix assignment of 0/1 to bool variables
From: Joe Perches <joe@perches.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: JBottomley@parallels.com, naresh@chelsio.com, davem@davemloft.net,
        jj@chaosbits.net, arvindb@chelsio.com, hare@suse.de,
        michaelc@cs.wisc.edu, vijay.chauhan@netapp.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Sun, 22 Sep 2013 17:29:29 -0700
In-Reply-To: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
References: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 20:44 +0200, Peter Senna Tschudin wrote:
> Convert 0 to false and 1 to true when assigning values to bool
> variables. Inspired by commit 3db1cd5c05f35fb43eb134df6f321de4e63141f2.
[]
> @@
> bool b;
> @@
> -b = 1
> +b = true

You might also look for non-zero values other than 1
and convert those true too.


