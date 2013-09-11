Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3IKU2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:28:38 -0400
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:49693 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753306Ab3IKU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:28:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3871:3872:4321:5007:7652:10004:10400:10848:11232:11473:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: room47_2dbb221c59041
X-Filterd-Recvd-Size: 1419
Message-ID: <1378931312.4714.26.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        George Spelvin <linux@horizon.com>, Jiri Kosina <jkosina@suse.cz>,
        Jan Beulich <jbeulich@suse.com>, Eldad Zack <eldad@fogrefinery.com>
Date: Wed, 11 Sep 2013 13:28:32 -0700
In-Reply-To: <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
References: <20130911193040.GA16688@www.outflux.net>
	 <1378929961.4714.21.camel@joe-AO722>
	 <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 13:18 -0700, Kees Cook wrote:
> I think Dan's idea of a WARN_ON_ONCE() here is a good idea to help
> anyone accidentally trying to use it.

Maybe WARN_ONCE so it's easier to emit the format too.


