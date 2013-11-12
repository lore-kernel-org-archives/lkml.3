Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3KLQ4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:56:53 -0500
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:35498 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753869Ab3KLQ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:56:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3867:3870:3871:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:8957:8985:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:13848,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cream50_3b976a1857741
X-Filterd-Recvd-Size: 1461
Message-ID: <1384275417.3665.1.camel@joe-AO722>
Subject: Re: scripts: checkpatch.pl & Lindent (minor complaint)
From: Joe Perches <joe@perches.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 08:56:57 -0800
In-Reply-To: <1384275104.5754.33.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384267377.5754.25.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1384271045.4771.47.camel@joe-AO722>
	 <1384272557.5754.30.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1384273839.4771.49.camel@joe-AO722>
	 <1384275104.5754.33.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 11:51 -0500, Mimi Zohar wrote:
> On Tue, 2013-11-12 at 08:30 -0800, Joe Perches wrote:
[]
> > My suggestion is not to use Lindent.
> > 
> > If you want a semi-automated source-code reformatting tool,
> > use scripts/checkpatch.pl --fix
> 
> Thanks, perhaps this suggestion should be reflected in
> Documentation/CodingStyle.

I sent a patch awhile ago

https://lkml.org/lkml/2013/2/11/390


