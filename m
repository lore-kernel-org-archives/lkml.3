Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbaFSQed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:34:33 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:46789 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933363AbaFSQe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:34:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:7652:8957:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plot34_6097fbc99f00f
X-Filterd-Recvd-Size: 1548
Message-ID: <1403195662.7875.5.camel@joe-AO725>
Subject: Re: [PATCH] Coccinelle: Script to drop parenthesis in the return
 statements
From: Joe Perches <joe@perches.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        benoit.taine@lip6.fr
Date: Thu, 19 Jun 2014 09:34:22 -0700
In-Reply-To: <20140619162954.GA4698@himangi-Dell>
References: <20140619162954.GA4698@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 21:59 +0530, Himangi Saraogi wrote:
> This script detects the use of a parenthesis around return value ot the
> return statements and removes them as they are unnecessary and against
> the CodingStyle. A new directory called checkpatch is added for semantic
> patches that just make patches for what checkpatch does. This will help
> developers having checkpatch problems, to run the semantic patches in this
> directory on their code and fix some of them automatically.

checkpatch already has --fix and --fix-inplace options that
do something similar.


