Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbbAURwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:52:20 -0500
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:46766 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751713AbbAURwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:52:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:152:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6261:7974:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13095:13161:13229:13311:13357:13894:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stone72_6a3440a6ed52b
X-Filterd-Recvd-Size: 2042
Message-ID: <1421862727.10574.25.camel@perches.com>
Subject: Re: [PATCH] of: Custom printk format specifier for device node
From: Joe Perches <joe@perches.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Jan 2015 09:52:07 -0800
In-Reply-To: <D84576D1-27F5-44F9-83DA-347C26F593FE@antoniou-consulting.com>
References: <1421859974-24507-1-git-send-email-pantelis.antoniou@konsulko.com>
	 <1421861843.10574.23.camel@perches.com>
	 <D84576D1-27F5-44F9-83DA-347C26F593FE@antoniou-consulting.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 19:39 +0200, Pantelis Antoniou wrote:
> Hi Joe,
> 
> > On Jan 21, 2015, at 19:37 , Joe Perches <joe@perches.com> wrote:
> > 
> > On Wed, 2015-01-21 at 19:06 +0200, Pantelis Antoniou wrote:
> >> 90% of the usage of device node's full_name is printing it out
> >> in a kernel message. Preparing for the eventual delayed allocation
> >> introduce a custom printk format specifier that is both more
> >> compact and more pleasant to the eye.
> >> 
> >> For instance typical use is:
> >> 	pr_info("Frobbing node %s\n", node->full_name);
> >> 
> >> Which can be written now as:
> >> 	pr_info("Frobbing node %pO\n", node);
> > 
> > Still disliking use of %p0.
> > 
> 
> Choices are limited. And it’s pO not p0.

Yet another reason to dislike it.

> > This isn't pretty.  Perhaps there's a better way?
> > 
> 
> No there isn’t.

There always is.


