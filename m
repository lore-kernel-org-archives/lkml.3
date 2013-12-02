Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3LBReK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:34:10 -0500
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:34296 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752837Ab3LBReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:34:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kite47_5dbf5b7a6fd5b
X-Filterd-Recvd-Size: 1449
Message-ID: <1386005643.2680.7.camel@joe-AO722>
Subject: Re: [PATCH 0/3] Add Firmware Info, Warn, and Bug messages
From: Joe Perches <joe@perches.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 02 Dec 2013 09:34:03 -0800
In-Reply-To: <1385997579-22240-1-git-send-email-prarit@redhat.com>
References: <1385997579-22240-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 10:19 -0500, Prarit Bhargava wrote:
> Logging and tracking firmware bugs in the kernel has long been an issue
> for system administrators.  The current kernel does not have a good
> uniform method of reporting firmware bugs and the code in the kernel is a
> mix of printk's and WARN_ONs.  This causes problems for both system
> administrators and QA engineers who attempt to diagnose problems within
> the kernel.

It'd be simpler if you introduced the macros in one patch
and then added patches that used them separately.

