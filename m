Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbaGXPwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:52:17 -0400
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:41216 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932207AbaGXPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:52:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3871:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone58_13626b7766457
X-Filterd-Recvd-Size: 1714
Message-ID: <1406217131.27221.27.camel@joe-AO725>
Subject: Re: [PATCH 00/10 linux-next] drivers/usb: remove unnecessary break
 after goto/return
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Oliver Neukum <oneukum@suse.de>, usb-storage@lists.one-eyed-alien.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Date: Thu, 24 Jul 2014 08:52:11 -0700
In-Reply-To: <2081121229.1044862.1406216802363.open-xchange@webmail.nmp.skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
	 <1406201840.729.4.camel@linux-fkkt.site>
	 <2081121229.1044862.1406216802363.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-24 at 17:46 +0200, Fabian Frederick wrote:
> 
> > On 24 July 2014 at 13:37 Oliver Neukum <oneukum@suse.de> wrote:
> >
> >
> > On Thu, 2014-07-24 at 10:18 +0200, Fabian Frederick wrote:
> > > Small patchset addressing break redundancy on drivers/usb branch
> > > (suggested by Joe Perches).
> >
> > Frankly, that is not a good idea. Somebody will remove a "goto"
> > and forget to readd the "break"
> 
> No problem ; checkpatch would give a warning anyway. See "Possible switch
> case/default not preceeded by break or fallthrough comment"

Generally true, but not everyone uses checkpatch.


