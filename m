Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaGHQgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:36:05 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:51036 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752106AbaGHQgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:36:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3871:3872:3873:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:14040:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sort10_34601238b4f02
X-Filterd-Recvd-Size: 1707
Message-ID: <1404837357.932.20.camel@joe-AO725>
Subject: Re: [PATCH v2 04/10] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 08 Jul 2014 09:35:57 -0700
In-Reply-To: <1404807878.5102.85.camel@smile.fi.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404751810.27043.90.camel@joe-AO725>
	 <1404807878.5102.85.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 11:24 +0300, Andy Shevchenko wrote:
> On Mon, 2014-07-07 at 09:50 -0700, Joe Perches wrote:
> > Perhaps better if -1 was accepted by string_escape_mem
> > as a strlen request or just ignored as a 0 length is
> > above.
> 
> Would it be any benefit here?

Dunno, it was just a thought for you.

> > fyi: hex_string emits nothing on printk("%ph", buf);
> 
> Works just fine. How did you check it?

By not reading the code correctly.
So what you have is fine.


