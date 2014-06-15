Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaFORrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:47:04 -0400
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:58301 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751723AbaFORrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:47:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2525:2553:2561:2564:2682:2685:2693:2828:2859:2899:2908:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3622:3867:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4397:5007:6117:7652:8599:8778:8985:9025:9388:10004:10400:10848:11232:11320:11658:11914:12043:12050:12114:12517:12519:12555:12682:12740:12776:13069:13311:13357:14106,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Cu
X-HE-Tag: screw88_3ce17d3965358
X-Filterd-Recvd-Size: 1727
Message-ID: <1402854416.2695.12.camel@joe-AO725>
Subject: Re: [PATCH] serial: samsung: Fix compile error with
 SERIAL_SAMSUNG_DEBUG
From: Joe Perches <joe@perches.com>
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 15 Jun 2014 10:46:56 -0700
In-Reply-To: <CAK5sBcGu2vFQFxqETgbLnu0AoMAhn9Zq5SEWNNzX=mr0yuWRdg@mail.gmail.com>
References: <1402776434-31613-1-git-send-email-cengelma@gmx.at>
	 <1402778036.2756.24.camel@joe-AO725>
	 <CAK5sBcGu2vFQFxqETgbLnu0AoMAhn9Zq5SEWNNzX=mr0yuWRdg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-15 at 23:06 +0530, Sachin Kamat wrote:
> On Sun, Jun 15, 2014 at 2:03 AM, Joe Perches <joe@perches.com> wrote:
> > Greg?  Can you please apply this soon?
> 
> A similar patch has already been posted [1]. Probably Greg will apply it
> once 3.16-rc1 is out.
> 
> [1] http://www.spinics.net/lists/linux-serial/msg12843.html

I know.  It was just another prompt to Greg.

It's just unfortunate to have a compile failure path
in Linus' tree.  Especially one I introduced.

He'd said 10 days ago or so it'd be a day or two.

http://www.spinics.net/lists/linux-serial/msg12859.html

cheers, Joe

