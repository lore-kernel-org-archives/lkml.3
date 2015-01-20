Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbbATSAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:00:02 -0500
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:54690 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752016AbbATR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:59:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6119:6261:7514:8526:9176:10004:10400:10848:11217:11232:11658:11914:12043:12296:12517:12519:12740:13019:13069:13095:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: star63_73cf3ec454e2e
X-Filterd-Recvd-Size: 2275
Message-ID: <1421776794.2724.1.camel@perches.com>
Subject: Re: [PATCH] of: Custom printk format specifier for device node
From: Joe Perches <joe@perches.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 20 Jan 2015 09:59:54 -0800
In-Reply-To: <E7065DB3-DD6B-4110-A066-8C7268186831@konsulko.com>
References: <1421764441-11928-1-git-send-email-pantelis.antoniou@konsulko.com>
	 <CAL_JsqLVJjq3Ov=J-5LtXiTQPLvR5Y=+tB1i16k_rN3j5dODFQ@mail.gmail.com>
	 <E7065DB3-DD6B-4110-A066-8C7268186831@konsulko.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 16:52 +0200, Pantelis Antoniou wrote:
> Hi Rob,
> 
> > On Jan 20, 2015, at 16:47 , Rob Herring <robherring2@gmail.com> wrote:
> > 
> > On Tue, Jan 20, 2015 at 8:34 AM, Pantelis Antoniou
> > <pantelis.antoniou@konsulko.com> wrote:
> >> 90% of the usage of device node's full_name is printing it out
> >> in a kernel message. Preparing for the eventual delayed allocation
> >> introduce a custom printk format specifier that is both more
> >> compact and more pleasant to the eye.
[]
> >> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
[]
> >> +Device tree nodes:
> >> +
> >> +       %pO{,1,2}
> > 
> > 'O' is not very obvious, but I imagine we are somewhat limted in our
> > choice here?
> > 
> 
> All the good women are married, all the handsome men are gay, all the obvious
> format specifiers are taken.

Not really at all.

I quite dislike '0' as the format type specifier for
a device tree node as there's no mnemonic mapping.



