Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaGVPJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:09:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbaGVPJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:09:14 -0400
Date: Tue, 22 Jul 2014 20:38:15 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, Amos Kong <akong@redhat.com>
Subject: Re: [PATCH v2 0/4] virtio-rng: contribute to early randomness
 requests
Message-ID: <20140722150815.GF32103@grmbl.mre>
References: <cover.1405942162.git.amit.shah@redhat.com>
 <20140722114623.GC18750@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722114623.GC18750@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 22 Jul 2014 [07:46:23], Jason Cooper wrote:
> On Mon, Jul 21, 2014 at 05:15:48PM +0530, Amit Shah wrote:
> > v2:
> >  - update patch 3 to store the hwrng_register_done bool per-device
> >    rather than global
> >  - add patch 2 that re-arranges struct elems for better packing.
> > 
> > Hi,
> > 
> > This series enables virtio-rng to service the early randomness
> > requests made by the hwrng core (patch 3), with Herbert's idea of
> > using the scan routine.
> > 
> > Patch 4 reverts the previous restriction, which no longer applies, to
> > not send read requests to the host before successful probe.
> > 
> > Patches 1 and 2 are minor cleanups.
> > 
> > Please review and apply,
> > 
> > Amit Shah (4):
> >   virtio: rng: remove unused struct element
> >   virtio: rng: re-arrange struct elements for better packing
> >   virtio: rng: delay hwrng_register() till driver is ready
> >   Revert "hwrng: virtio - ensure reads happen after successful probe"
> > 
> >  drivers/char/hw_random/core.c       |  6 ------
> >  drivers/char/hw_random/virtio-rng.c | 39 ++++++++++++++++---------------------
> >  2 files changed, 17 insertions(+), 28 deletions(-)
> 
> fwiw,
> 
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
> 
> Thanks for putting this together Amit!

Thanks, Jason!

		Amit
