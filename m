Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaJUQvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:51:25 -0400
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:57357 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932765AbaJUQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:51:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3868:3871:3874:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cable49_292acf15e3c02
X-Filterd-Recvd-Size: 1367
Message-ID: <1413910281.12828.6.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Improve warning message for "needless if"
 case
From: Joe Perches <joe@perches.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 21 Oct 2014 09:51:21 -0700
In-Reply-To: <CAOMZO5BjP=o0EsQJoA_ddYYPGJhY1tUVy6mbA1_tGhd2VUJFEw@mail.gmail.com>
References: <1413902024-2932-1-git-send-email-fabio.estevam@freescale.com>
	 <1413909608.12828.5.camel@perches.com>
	 <CAOMZO5BjP=o0EsQJoA_ddYYPGJhY1tUVy6mbA1_tGhd2VUJFEw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 14:44 -0200, Fabio Estevam wrote:
> On Tue, Oct 21, 2014 at 2:40 PM, Joe Perches <joe@perches.com> wrote:
> 
> >
> > Mixing sentences with and without periods is jarring.
> > I'd prefer a comma or a dash.
> 
> Or what about?
> 
> "is safe and this check is probably not required"

That'd be fine too

