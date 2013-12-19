Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3LSBQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:16:00 -0500
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:47043 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750872Ab3LSBP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:15:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:8985:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,
X-HE-Tag: ink74_6e05c5fbf560d
X-Filterd-Recvd-Size: 1617
Message-ID: <1387415754.13593.57.camel@joe-AO722>
Subject: Re: [PATCH] silicom: fixed checkpatch issues in bypass.c
From: Joe Perches <joe@perches.com>
To: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
Cc: linux-kernel@i4.cs.fau.de, Christoph Kohl <christoph.kohl@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chad Williamson <chad@dahc.us>, Randy Dunlap <rdunlap@infradead.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 18 Dec 2013 17:15:54 -0800
In-Reply-To: <1387410312-32301-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
References: <1387410312-32301-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 00:45 +0100, Michael Hoefler wrote:
> This patch cleans up bypass.c of the silicom driver in the staging area. All
> errors and most warnings according to checkpatch.pl should be fixed.

When you make patch against staging, please use the
latest staging-next branch of the staging tree.

https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/

This tree is also available part of the -next tree.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/


