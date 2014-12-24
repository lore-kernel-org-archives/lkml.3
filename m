Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaLXFor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:44:47 -0500
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:49238 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893AbaLXFoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:44:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6261:6742:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plate09_805f3f725954e
X-Filterd-Recvd-Size: 1958
Message-ID: <1419399879.6157.9.camel@perches.com>
Subject: Re: [PATCH] linux/kernel.h: merge ARRAY_AND_SIZE defines
From: Joe Perches <joe@perches.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Daniel Mack <daniel@zonque.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michal Nazarewicz <mina86@mina86.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Elder <alex.elder@linaro.org>, Daniel Walter <dwalter@google.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Date: Tue, 23 Dec 2014 21:44:39 -0800
In-Reply-To: <1419399496-5955-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1419399496-5955-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-24 at 14:38 +0900, Masahiro Yamada wrote:
> ARRAY_AND_SIZE is a useful macro.  Its definition is already
> duplicated in some headers.  Move it to include/linux/kernel.h.

I think it's not a good/useful macro and
would prefer the uses expanded instead.

The uses of ARRAY_AND_SIZE in structure
definitions aren't particularly bad, but the
ARRAY_AND_SIZE uses that hide the number of
arguments in a function I think are suboptimal.


