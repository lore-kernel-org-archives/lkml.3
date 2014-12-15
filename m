Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaLOXxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:53:22 -0500
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:47986 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310AbaLOXxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:53:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:421:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3871:3872:3873:4250:4321:5007:6261:6742:8603:8828:10004:10400:10471:10848:11232:11658:11914:12517:12519:12663:12740:13069:13071:13255:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dogs70_56fb2595fa847
X-Filterd-Recvd-Size: 1914
Message-ID: <1418687596.2674.25.camel@perches.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c:
 Fix for possible null pointer dereference
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2014 15:53:16 -0800
In-Reply-To: <CAFo99gaVUbsvwY7RKZ9D=c0jnVeFiBLAeNVb53UX=Ba4XytoKg@mail.gmail.com>
References: <1418597547-25086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1418608297.2674.4.camel@perches.com>
	 <CAFo99gaVUbsvwY7RKZ9D=c0jnVeFiBLAeNVb53UX=Ba4XytoKg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 23:23 +0100, Rickard Strandqvist wrote:
> Hi Joe

Hello Rickard

> No, it does not look like end can be NULL then.
> Then remove the end != NULL instead?
> ...
>     if (end != NULL && *end == '.') {

Up to you.

> However, I am hesitant to the tolower()  I think double case is faster...?

I doubt code execution speed is paramount here.
Maybe see if the object code size is smaller one
way or the other.


