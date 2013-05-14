Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab3ENTy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:54:59 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13384 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3ENTy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:54:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 14 May 2013 15:54:51 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Pavel Machek <pavel@ucw.cz>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] ARM: delay: print dummy values for bogomips
In-reply-to: <5188B8B2.5030601@arm.com>
Message-id: <alpine.LFD.2.03.1305141547180.31158@syhkavp.arg>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
 <1367602547-19322-2-git-send-email-will.deacon@arm.com>
 <20130506231554.GB16801@amd.pavel.ucw.cz> <5188B8B2.5030601@arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Yes, I'm late to the party ]

On Tue, 7 May 2013, Marc Zyngier wrote:

> On 07/05/13 00:16, Pavel Machek wrote:
> 
> Hi Pawel,
> 
> >> Now that we support a timer-backed delay loop, I'm quickly getting sick
> >> and tired of people complaining that their beloved bogomips value has
> >> decreased. You know who you are!
> > 
> >> Unfortunately, we can't just remove the entry from /proc/cpuinfo, as it
> >> will likely break fragile userspace code which is parsing that stuff, so
> >> instead replace it with a dummy value that can be chosen in the
> >> Kconfig.
> > 
> > So, instead of removing it you silently report invalid value? Note
> 
> Removing it would be an ABI breakage. Unfortunately.

Did you really write this with a straight face?

> Name one userspace application that extracts meaningful information out
> of the BogoMIPS field. Just one.

Waitaminute... Didn't you just claim this would be an ABI break?

So if no application can be found, where is the ABI breakage?

This thread must be a joke.  Please just kill the damn thing out of 
/proc/cpuinfo and see if any application notices.  And if some do then 
they are already broken *today* and should be fixed.


Nicolas
