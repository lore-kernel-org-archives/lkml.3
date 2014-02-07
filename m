Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBGOqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:46:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaBGOqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:46:33 -0500
Message-ID: <1391784386.5475.103.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.9-rt13
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Fri, 07 Feb 2014 15:46:26 +0100
In-Reply-To: <20140207085701.GB23668@linutronix.de>
References: <20140203194841.GA17108@linutronix.de>
	 <1391526218.5532.33.camel@marge.simpson.net>
	 <20140207085701.GB23668@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:esQ+a7OVkupeNtosEVL5GZJpdIEdg8EVgOuaOEmsWDV
 Exa8FTw4Sdyop2lSh8WsOIqtTcQrG92PVEuZOOfwylWTMkzH8r
 ao7vboTY5tcd4vA6MT1DaoI8RnUPRV88wFGdpbtXY2xim1hyBG
 gUcrNKTDxNRvGA4JaBAWkmtmqs/Howcxbb1U2Myw1il7VRlMsx
 n8d4Yz/XuCiI+2zdYmfl5CC4auntKLxxS2TM9B96RSOP5vd1kr
 Ws5P2inCYqJb3+cu/+JY2lvz2fOhAhktH2wD0mRRho2gcs0jOA
 5ooUTm3xnItLGQ4b2TRTlrTSeUVZf0XaMwpBk93E4AqjyU+91H
 tawMrBIYGLIXlIY/a/UVh93oUeWl77RH9g75g3+wo9WpalUQQ1
 tM69pqnpXI26A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 09:57 +0100, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2014-02-04 16:03:38 [+0100]:
> 
> >On Mon, 2014-02-03 at 20:48 +0100, Sebastian Andrzej Siewior wrote:
> >
> >> Known issues:
> >
> >> Mike said that it caused two of his 64 CPUs to spin for five minutes
> >>         doing nothing. Therefore it is disabled in the queue. Everyone
> >>         who wants test it may do so :)
> >
> >I put rt13 on an 8 socket Opetron (48 core) box, with patch enabled.  It
> >box did NOT reproduce the hangs the 8 socket (1 node, bleh) DL980 did.
> >
> >Nor did it explode running hotplug stress, but then it deadlocks before
> >BOOM would have happened on the DL980.  kdump isn't working properly on
> >this box (not an rt issue, userspace), so..
> 
> Okay, so this is at some point good news. Thank you.

I've been letting other big boxen play around the clock distro build
slave and whatnot, with no sign of trouble.

I'm raising an eyebrow in the general direction of DL980 test box.  Its
microscopic, and more importantly, unsupported, memory configuration
might be more than a mere performance hindrance.

-Mike

