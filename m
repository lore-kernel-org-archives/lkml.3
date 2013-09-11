Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3IKFAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:00:39 -0400
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:40737 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752922Ab3IKFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:00:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jump97_5c1f0eab61261
X-Filterd-Recvd-Size: 1124
Message-ID: <1378875632.606.5.camel@joe-AO722>
Subject: Re: [PATCH] staging: dgnc: fix potential format string flaw
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Tushar Behera <tushar.behera@linaro.org>, devel@driverdev.osuosl.org
Date: Tue, 10 Sep 2013 22:00:32 -0700
In-Reply-To: <20130911044116.GA17294@www.outflux.net>
References: <20130911044116.GA17294@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 21:41 -0700, Kees Cook wrote:
> Make sure that format strings cannot leak into printk() calls from the
> msgbuf string.

	printf(string);
vs
	printf("%s", string);

How does this help?


