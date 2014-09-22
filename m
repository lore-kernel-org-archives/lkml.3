Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaIVW7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:59:07 -0400
Received: from ozlabs.org ([103.22.144.67]:39381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbaIVW7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:59:05 -0400
Message-ID: <1411426743.25517.0.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH 03/15] powerpc/msi: Improve IRQ bitmap allocator
From: Michael Neuling <mikey@neuling.org>
To: Laurentiu Tudor <b10716@freescale.com>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, cbe-oss-dev@lists.ozlabs.org,
        imunsie@au.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Date: Tue, 23 Sep 2014 08:59:03 +1000
In-Reply-To: <541FDDD6.9040009@freescale.com>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-4-git-send-email-mikey@neuling.org>
	 <541FDDD6.9040009@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
> > index 2ff6302..e001559 100644
> > --- a/arch/powerpc/sysdev/msi_bitmap.c
> > +++ b/arch/powerpc/sysdev/msi_bitmap.c
> > @@ -24,28 +24,36 @@ int msi_bitmap_alloc_hwirqs(struct msi_bitmap *bmp, int num)
> >  	 * This is fast, but stricter than we need. We might want to add
> >  	 * a fallback routine which does a linear search with no alignment.
> >  	 */
> 
> Is this comment still relevant (especially the part mentioning "fast")?

You're right, it's not really relevant any more.  I'll remove.

Thanks
Mikey

