Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaJKSXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:23:05 -0400
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:55781 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751006AbaJKSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:23:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:7875:7903:10004:10400:10848:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mark87_718c89554e002
X-Filterd-Recvd-Size: 1822
Message-ID: <1413051779.22149.8.camel@joe-AO725>
Subject: Re: [alsa-devel] [PATCH v2 2/2] ALSA: au88x0: pr_* replaced with
 dev_*
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Raymond Yau <superquad.vortex2@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>
Date: Sat, 11 Oct 2014 11:22:59 -0700
In-Reply-To: <CADVatmPiWEm9wBENVVytUqCOV_Yv9HojmHYJGDAmyGpwhcCU8A@mail.gmail.com>
References: <1412930199-24797-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <1412930199-24797-2-git-send-email-sudipm.mukherjee@gmail.com>
	 <CAN8ccibSw_85wdnxbNSKfjXQ-7Lg3C6_5fhKQJJi5xMi8pMabA@mail.gmail.com>
	 <20141011090903.GC8231@sudip-PC> <1413024491.16385.10.camel@joe-AO725>
	 <20141011113349.GA9962@sudip-PC> <1413041569.16385.20.camel@joe-AO725>
	 <CADVatmPiWEm9wBENVVytUqCOV_Yv9HojmHYJGDAmyGpwhcCU8A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 23:40 +0530, Sudip Mukherjee wrote:
> now in this case what will you suggest - shutdown and done both
> terminated by \n or some thing like : "shutdown process started" and then
> "shutdown done"....

I think it doesn't matter one way or another as
it's only useful when there's a hang in the init
or shutdown.

It is better though to have complete messages
terminated with newlines so that it is not possible
for other threads to confusingly interleave output.


