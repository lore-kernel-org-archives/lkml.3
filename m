Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaKCPIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:08:16 -0500
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:57151 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752370AbaKCPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:08:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:4384:4385:4395:5007:6261:7903:10004:10400:10848:10967:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:14096:14097:21060:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: play36_2a4f50d717c02
X-Filterd-Recvd-Size: 1703
Message-ID: <1415027288.17743.16.camel@perches.com>
Subject: Re: [PATCH v2 1/2] ALSA: echoaudio: add reference of struct
 echoaudio
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Nov 2014 07:08:08 -0800
In-Reply-To: <s5hwq7c1i7k.wl-tiwai@suse.de>
References: <1415010853-4334-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <s5hwq7c1i7k.wl-tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 15:17 +0100, Takashi Iwai wrote:
> At Mon,  3 Nov 2014 16:04:12 +0530,
> Sudip Mukherjee wrote:
> > 
> > added reference of struct echoaudio to free_firmware function.
> > this structure will be later used to get a reference of the card
> > when converting snd_printk to dev_* in the next patch of the series.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> 
> Thanks, now applied both.  Though, I noticed that there is also a
> dev_notice() usage that should be also dev_dbg().  Corrected such
> lines in my side.

Are any of these changes going to cause a
null pointer dereference of chip->card->dev?

ftrace exists and is generic.

Several of these seem to be function tracing
style uses and should just be deleted instead.


