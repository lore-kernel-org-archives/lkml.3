Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaC1HP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:15:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50911 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbaC1HPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:15:54 -0400
X-Sasl-enc: gg82Fq21aa2Ynk4t4FI9fonK31d3/M4r4DeRYQxafihY 1395990952
Date: Fri, 28 Mar 2014 00:17:43 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, dtor@mail.ru,
        linux-input@vger.kernel.org, jkosina@suse.cz,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Richard Purdie <rpurdie@rpsys.net>,
        LKML <linux-kernel@vger.kernel.org>, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 8 months to review a patch (was Re: [PATCH] Route kbd LEDs
 through the generic LEDs layer)
Message-ID: <20140328071743.GA17588@kroah.com>
References: <20110102225741.GX5480@const.famille.thibault.fr>
 <20110112182702.GA9168@core.coreip.homeip.net>
 <20111114040613.GA4992@type.famille.thibault.fr>
 <20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
 <20130713093552.GU8252@type>
 <20130715091230.GA8786@amd.pavel.ucw.cz>
 <CAHYPw2H94ej=FdqHAxXpyZt+34TwK1Qj7LWP_bMro-v3JREisg@mail.gmail.com>
 <20140316101946.GJ6436@type.youpi.perso.aquilenet.fr>
 <CAHYPw2EAgjdcNATy0d6DhbT9qHAHJLda7gsLrnSJ7F4Cj=a-JQ@mail.gmail.com>
 <20140328070136.GA15953@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140328070136.GA15953@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 08:01:36AM +0100, Pavel Machek wrote:
> On Thu 2014-03-27 02:08:17, Pali Rohár wrote:
> > 2014-03-16 11:19 GMT+01:00 Samuel Thibault <samuel.thibault@ens-lyon.org>:
> > > Pali Rohár, le Sun 16 Mar 2014 11:16:25 +0100, a écrit :
> > >> Hello, what happened with this patch? Is there any problem with accepting it?
> > >
> > > Dmitry finding time to review it, I guess.
> 
> > Dmitry, can you look and review this patch?
> 
> Dmitry, what happened to you, are you there? This patch is like 8
> months old, and not too scary, either. Can you at least pinpoint some
> typos in it, or run in through the checkpatch?
> 
> If Dmitry does not respond, what are the next steps. Greg, could you
> just take the patch? Linus?

No, work with Dmitry please.

