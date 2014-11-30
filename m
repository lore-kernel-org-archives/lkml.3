Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaK3E53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 23:57:29 -0500
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:46841 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751895AbaK3E5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 23:57:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:152:355:379:541:560:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2827:3138:3139:3140:3141:3142:3622:3867:3868:3871:3872:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12533:12740:13069:13311:13357:13894:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: north56_407815d334c62
X-Filterd-Recvd-Size: 1289
Message-ID: <1417323441.818.4.camel@perches.com>
Subject: Re: [PATCH] sound: use enum names instead of magic numbers
From: Joe Perches <joe@perches.com>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Sat, 29 Nov 2014 20:57:21 -0800
In-Reply-To: <547AA272.6070308@sakamocchi.jp>
References: <1417201196-12392-1-git-send-email-KyleChamberlin@project20million.org>
	 <s5h7fydbv6w.wl-tiwai@suse.de> <1417294692.818.3.camel@perches.com>
	 <547AA272.6070308@sakamocchi.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-30 at 13:52 +0900, Takashi Sakamoto wrote:
> On 2014年11月30日 05:58, Joe Perches wrote:
> > There's an enum defined for these magic numbers,
> > might as well use it.
[]
> I think it better to split this patch into two parts, one is for
> enumeration identifier and another is for variadic macro.

Go ahead then.


