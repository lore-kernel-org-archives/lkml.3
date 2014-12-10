Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbaLJVoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:44:54 -0500
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:46728 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932426AbaLJVoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:44:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2551:2553:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6261:8985:9025:9040:10004:10400:10848:11232:11658:11914:12043:12050:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mice37_81c4f3329ad55
X-Filterd-Recvd-Size: 1427
Message-ID: <1418247890.18092.20.camel@perches.com>
Subject: Re: [PATCH] drivers: cpuidle: Added a blank line after declarations
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Anjana Sasindran <anjanasasindran123@gmail.com>, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Dec 2014 13:44:50 -0800
In-Reply-To: <354575085.t1Bv5Pht3m@vostro.rjw.lan>
References: <1418233044-12059-1-git-send-email-anjanasasindran123@gmail.com>
	 <354575085.t1Bv5Pht3m@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 22:45 +0100, Rafael J. Wysocki wrote:
> On Wednesday, December 10, 2014 11:07:24 PM Anjana Sasindran wrote:
> > This patch fix the checkpatch.pl warning:
> > 
> > WARNING: Missing blank line after declarations
> 
> Please send a patch to checkpatch.pl maintainers to make it not complain in
> this case instead.  Thanks!

Direct any plaints to Andrew Morton and Greg KH instead.
I don't care one way or another.

https://lkml.org/lkml/2014/3/6/550
https://lkml.org/lkml/2014/3/10/457


