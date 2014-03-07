Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaCGQIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:08:15 -0500
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:43846 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751578AbaCGQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:08:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3873:4250:4321:4362:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dogs73_474762121e85c
X-Filterd-Recvd-Size: 1363
Message-ID: <1394208487.16156.62.camel@joe-AO722>
Subject: Re: [PATCH v3 0/4] checkpatch: enhance compatible string checking
From: Joe Perches <joe@perches.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Andy Whitcroft <apw@canonical.com>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Mar 2014 08:08:07 -0800
In-Reply-To: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 14:26 +0100, Florian Vaussard wrote:
> Joe: I have split your patch to perform atomic changes. I also
> merged one part into one of my patch. I added your S-o-B on the
> corresponding patches, I let you check if you are OK with the changes.

Could you please send a clean V4 without my SOB and add
Andrew Morton <akpm@linux-foundation.org> to the cc's?

Andrew is generally the path to get checkpatch changes
upstream.

Thanks. Joe

