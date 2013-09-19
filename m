Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3ISSeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:34:07 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:35728 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752045Ab3ISSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:34:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:4321:5007:7652:7875:7903:8784:10004:10400:10848:11232:11473:11658:11914:12517:12519:12740:13069:13158:13228:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wheel43_5d868d9305905
X-Filterd-Recvd-Size: 1509
Message-ID: <1379615641.22168.15.camel@joe-AO722>
Subject: Re: [PATCH v1 5/6] bitops: Introduce BIT_ULL
From: Joe Perches <joe@perches.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, gregkh@linuxfoundation.org,
        len.brown@intel.com, rjw@sisk.pl, arjan@linux.intel.com,
        jacob.jun.pan@linux.intel.com
Date: Thu, 19 Sep 2013 11:34:01 -0700
In-Reply-To: <523B43BC.2020701@linux.intel.com>
References: <1379606435-15871-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <1379606435-15871-6-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <20130919164830.GB9427@pd.tnic> <523B2F57.2050504@linux.intel.com>
	 <20130919172819.GD9412@pd.tnic> <1379614490.22168.7.camel@joe-AO722>
	 <523B43BC.2020701@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 11:34 -0700, Srinivas Pandruvada wrote:

> Let's do in two steps:
> - In the next patcheset I will add BIT_ULL_MASK and BIT_ULL_WORD in 
> addition to BIT_ULL
> - Once this series is approved, submit a separate patch to change BIT_64 
> to BIT_ULL

Fine by me.


