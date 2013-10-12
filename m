Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3JLQIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 12:08:22 -0400
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:47266 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752157Ab3JLQIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 12:08:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:857:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2124:2194:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:3874:4043:4250:4321:5007:6119:7652:7903:9108:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:13618,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: list93_e60e4ee8c209
X-Filterd-Recvd-Size: 2897
Message-ID: <1381594098.8864.9.camel@joe-AO722>
Subject: Re: [PATCH 2/2] framebuffer: Remove pmag-aa-fb
From: Joe Perches <joe@perches.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Date: Sat, 12 Oct 2013 09:08:18 -0700
In-Reply-To: <alpine.LFD.2.03.1310121308310.10951@linux-mips.org>
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
	 <6f500d88eb23fd9a4cfc5583f5ca17bc5f58fe24.1379641901.git.joe@perches.com>
	 <CAMuHMdW6R5qTJ0uvsUUaYBZAqFcNshPsXeMbz5hwqq5UOkJr-g@mail.gmail.com>
	 <alpine.LFD.2.03.1309201907380.8379@linux-mips.org>
	 <1379702587.2301.12.camel@joe-AO722>
	 <alpine.LFD.2.03.1309201946430.8379@linux-mips.org>
	 <alpine.LFD.2.03.1310121308310.10951@linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-12 at 14:08 +0100, Maciej W. Rozycki wrote:
[]
> So I think I've got all the basic stuff covered now, including a change 
> similar to your proposal as well as a conversion to the driver model/new 
> TURBOchannel support infrastructure.  But what I remembered is actually 
> right, the issue is wiring hardware cursor support into fbcon.  The driver 
> uses its own display_switch structure with its own aafbcon_cursor handler 
> to use the twin onboard Bt431 chips for cursor generation (there's also 
> aafbcon_set_font that pokes at the Bt431s for cursor dimension changes).  
> I need to figure out what the best way will be to make the fbcon subsystem 
> support such an arrangement and that'll take me a little bit yet, so 
> please be patient.
> 
> Note that the board is weird enough to have a 1-bit (true monochrome) 
> graphics plane, however the Bt455 used by the MX graphics adapter for 
> screen image generation is a 4-bit grey-scale video RAMDAC (only the LSB 
> inputs of its pixel port are wired to the graphics plane) and the twin 
> Bt431s use the overlay plane to produce a 2-bit grey-scale cursor.  So we 
> do want to use the hardware cursor to be able to make it prominent among 
> the characters displayed throughout the screen and a software-generated 
> cursor cannot really substitute what hardware provides.

I hope you're enjoying tinkering with old toys.

Best of luck getting it going.


