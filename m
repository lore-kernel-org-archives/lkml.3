Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3JPB5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 21:57:25 -0400
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:56448 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751147Ab3JPB5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 21:57:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3352:3622:3865:3867:3868:3870:3872:3874:4321:5007:6119:7652:7875:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13018:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: basin77_5d198d23d611b
X-Filterd-Recvd-Size: 1675
Message-ID: <1381888638.22110.43.camel@joe-AO722>
Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Tue, 15 Oct 2013 18:57:18 -0700
In-Reply-To: <20131011154759.GJ5925@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
	 <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com>
	 <20131011090630.GB5925@pd.tnic> <20131011154759.GJ5925@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 17:47 +0200, Borislav Petkov wrote:
> On Fri, Oct 11, 2013 at 11:06:30AM +0200, Borislav Petkov wrote:
> > > -	printk("%s""APEI generic hardware error status\n", pfx);
> > > +	printk("%s""Generic Hardware Error Status\n", pfx);
> > 
> > Btw, what's the story with printk not using KERN_x levels in this file?
> > Why are we falling back to default printk levels for all printks here
> > and shouldn't we rather prioritize them by urgency into, say, KERN_ERR,
> > KERN_INFO, etc?
> 
> Ignore that - checkpatch complained about it but I kinda missed that
> we're handing down the prefix.

I think it'd be better to rename pfx to level
as that's what printk.h calls them.




