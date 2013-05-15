Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab3EOMfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:35:08 -0400
Received: from relais.videotron.ca ([24.201.245.36]:8627 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab3EOMfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:35:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 15 May 2013 08:34:51 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Will Deacon <will.deacon@arm.com>, Rob Herring <robherring2@gmail.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] ARM: delay: print dummy values for bogomips
In-reply-to: <20130515114737.GA7900@amd.pavel.ucw.cz>
Message-id: <alpine.LFD.2.03.1305150830540.31158@syhkavp.arg>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
 <1367602547-19322-2-git-send-email-will.deacon@arm.com>
 <20130506231554.GB16801@amd.pavel.ucw.cz> <5188B8B2.5030601@arm.com>
 <alpine.LFD.2.03.1305141547180.31158@syhkavp.arg>
 <CAL_Jsq+Q5UMGo3J+vKKCRU+w4Kj0YN0exs7UCWTEOxmFjWfo3g@mail.gmail.com>
 <alpine.LFD.2.03.1305141945160.31158@syhkavp.arg>
 <20130515090103.GA12907@mudshark.cambridge.arm.com>
 <20130515114737.GA7900@amd.pavel.ucw.cz>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013, Pavel Machek wrote:

> On Wed 2013-05-15 10:01:03, Will Deacon wrote:
> > My second (less stupid) version of the patch prints "not reported".

Even then, you should tell the truth and say "not available" or "not 
applicable".

> > I'd be happy to remove the line altogether if people get behind the 
> > decision though.

You certainly have my ACK.

> > In fact, I just tried it and at least my linaro filesystem seems happy
> > enough.
> 
> Would it be too much work to simply put the field back with the right
> value? We don't have to get it as precise as we used to, that should
> make slowdown minimum.

There is simply no right value.  And whenever there is a value, people 
read too much into it.


Nicolas
