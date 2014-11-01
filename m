Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbaKAFOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:14:39 -0400
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:37136 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752245AbaKAFOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:14:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6742:7652:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13095:13141:13230:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: light99_7f5de8f640e57
X-Filterd-Recvd-Size: 2132
Message-ID: <1414818870.31550.1.camel@perches.com>
Subject: Re: [PATCH v2 1/6] staging: ft1000: spaces required around that
 '=', '<' and '=='
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Chen Weixiang <weixiangchen@gmail.com>,
        Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 31 Oct 2014 22:14:30 -0700
In-Reply-To: <20141101050535.GC3642@sudip-PC>
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
	 <1414810047-6975-2-git-send-email-weixiang.chen@gmail.com>
	 <20141101050535.GC3642@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-01 at 10:35 +0530, Sudip Mukherjee wrote:
> On Sat, Nov 01, 2014 at 10:47:22AM +0800, Chen Weixiang wrote:
> > Remove following code style errors from ft1000/ft1000-usb/ft1000_debug.c
> > and ft1000/ft1000-pcmcia/ft1000_hw.c:
> > ERROR: spaces required around that '=' (ctx:VxV)
> > ERROR: spaces required around that '<' (ctx:VxV)
> > ERROR: spaces required around that '==' (ctx:VxV)
> > 
> 
> many whitespace errors in the patch.
> checkpatch gives total: 8 errors, 23 warnings, 125 lines checked

When fixing one thing (like spacing), it's pretty
expected to have more checkpatch errors.

It's a process, don't worry about most intermediate
warnings when doing checkpatch cleanups.

Adding trailing spaces is not good, nearly every
other type of message can be ignored.

