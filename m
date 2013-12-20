Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3LTJX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:23:58 -0500
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:57486 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755665Ab3LTJX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:23:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:3870:3871:3872:3873:4250:4321:5007:6119:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fold95_3f0d31d7e9f18
X-Filterd-Recvd-Size: 1560
Message-ID: <1387531432.2353.44.camel@joe-AO722>
Subject: Re: checkpatch.pl error might be false positive
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ravi Patel <rapatel@apm.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Whitcroft <apw@canonical.com>, Kumar Sankaran <ksankaran@apm.com>,
        Loc Ho <lho@apm.com>, Keyur Chudgar <kchudgar@apm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Dec 2013 01:23:52 -0800
In-Reply-To: <20131220091621.GC21784@leaf>
References: <CAN1v_PvS3dH6HVQ90d=3cfsSdMgieyoDNp3VN-vrHv-aqSFEAw@mail.gmail.com>
	 <1387491348.2353.20.camel@joe-AO722> <20131220075634.GA21784@leaf>
	 <1387528630.2353.39.camel@joe-AO722> <20131220091621.GC21784@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 01:16 -0800, Josh Triplett wrote:
> Duplicating the regex seems awful.  Could you put it in a variable?

awful is a strong word and I don't have any
issue with the duplication.  Using a variable
is just as confusing as any duplication.

Using a separate test and message for the GPL
vs the FSF bits would likely be better anyway.

You're the original FSF address patch submitter,
fix it as you think appropriate.

