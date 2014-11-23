Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaKWTGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:06:34 -0500
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:57912 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751670AbaKWTGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:06:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:965:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3873:3874:4321:4390:5007:6119:6261:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: list83_55f62dd8fe738
X-Filterd-Recvd-Size: 2533
Message-ID: <1416769586.6651.49.camel@perches.com>
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Andreas Noever <andreas.noever@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Date: Sun, 23 Nov 2014 11:06:26 -0800
In-Reply-To: <54722F88.8050805@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net>
	 <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>
	 <546F2E50.5040804@users.sourceforge.net>
	 <1416593688.6651.39.camel@perches.com>
	 <5471EBAC.40903@users.sourceforge.net>
	 <1416756022.6651.45.camel@perches.com>
	 <54720061.7010401@users.sourceforge.net>
	 <alpine.DEB.2.02.1411231650580.2037@localhost6.localdomain6>
	 <54722F88.8050805@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-23 at 20:03 +0100, SF Markus Elfring wrote:
> > Why not just make the static source code analysis aware of the problem?
> 
> This is also possible, of course.
> 
> 
> > You can treat static functions differently that non-static ones.
> 
> I have added this detail to my ideas around the next fine-tuning
> for the published semantic patch approach.
> 
> 
> > There is no need to change the code.
> 
> Can name space prefixes help to make source code a bit safer eventually?

Not really.
Adding prefixes can make code unnecessarily more verbose though.

