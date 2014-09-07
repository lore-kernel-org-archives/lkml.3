Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaIGOKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 10:10:17 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:38644 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752251AbaIGOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 10:10:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:7875:7903:8985:9025:10004:10400:10848:11232:11658:11914:12043:12050:12517:12519:12663:12740:13069:13071:13311:13357:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wood21_1f648fc7883d
X-Filterd-Recvd-Size: 1562
Message-ID: <1410099012.2723.13.camel@joe-AO725>
Subject: Re: Error in scripts/checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Daniel Bomar <dbdaniel42@gmail.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Sun, 07 Sep 2014 07:10:12 -0700
In-Reply-To: <CAMXhOsrZfqvB3YDvdATwBAd9OJCxuAZWkdukenzLp4VKyZ_Svw@mail.gmail.com>
References: <CAMXhOsrZfqvB3YDvdATwBAd9OJCxuAZWkdukenzLp4VKyZ_Svw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-07 at 04:39 -0500, Daniel Bomar wrote:
> Hello, I'm new to all this so please correct me if I'm sending this to
> the wrong place.  I'd like to report the following error that shows
> whenever I run scripts/checkpatch.pl.  The error shows at the top of
> the output after which the script appears to function normally.  I'm
> running Arch Linux and Perl version 5.20.0.  The error is as follows:
> 
> Useless use of greediness modifier '+' in regex; marked by <-- HERE in
> m/(^\+.*) {8,8}+ <-- HERE \t/ at scripts/checkpatch.pl line 2424.

Hello.  Thanks for the report.

A patch to fix this was submitted a couple
of months ago.  It just takes awhile to
get into the appropriate trees.

https://lkml.org/lkml/2014/7/11/809


