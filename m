Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3EKDHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 23:07:22 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:35348 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3EKDHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 23:07:20 -0400
Date: Fri, 10 May 2013 23:07:13 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-iMac
To: Parag Warudkar <parag.lkml@gmail.com>
cc: =?ISO-8859-15?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        =?ISO-8859-15?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] radeon: Allow disabling UVD
In-Reply-To: <alpine.DEB.2.02.1305081730440.7947@parag-iMac>
Message-ID: <alpine.DEB.2.02.1305102303350.2630@parag-iMac>
References: <CAOULuOb79h99RiyYpMGLzzM2QeawYfG8CfrvNtk4WtJJxRn87g@mail.gmail.com> <1367910123.12136.7.camel@thor.local> <5188BEF7.7090505@vodafone.de> <CAOULuObffavZs9+p-C_C5Y6y=6aJhnYVf_d0nXWXb9Zt2A7rBw@mail.gmail.com> <518A1B94.6090001@vodafone.de>
 <alpine.DEB.2.02.1305081730440.7947@parag-iMac>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-2081765409-1368241638=:2630"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2081765409-1368241638=:2630
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Wed, 8 May 2013, Parag Warudkar wrote:

> 
> 
> On Wed, 8 May 2013, Christian König wrote:
> 
> > If you want to hack a bit on it you could try commenting out the calls to
> > "radeon_set_uvd_clocks" in radeon_uvd.c. That should give you the default
> > clocks of 100Mhz, not enough for usable decoding, but on SUMO based UVD blocks
> > a very failsafe default.

Commenting out the two calls to radeon_set_uvd_clocks() did not make any 
difference - still fails to initialize. BTW, this is also an EFI install. 
Sounds like for some people BIOS mode works based on the bug report.

Also confirming  that the suspend/resume issue persists with the 
SUMO_uvd.bin firmware loaded even if the UVD init fails. It is only by 
removing the firmware I can get the machine to suspend reliably.

Parag 
--8323329-2081765409-1368241638=:2630--
