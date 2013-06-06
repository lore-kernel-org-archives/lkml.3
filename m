Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab3FFIo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:44:28 -0400
Received: from 9.mo5.mail-out.ovh.net ([178.32.96.204]:45647 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754580Ab3FFIo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:44:27 -0400
Date: Thu, 6 Jun 2013 10:33:00 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] mmc: atmel-mci: remove include <mach/cpu.h>
Message-ID: <20130606083300.GJ23653@game.jcrosoft.org>
References: <1365511500-13778-1-git-send-email-nicolas.ferre@atmel.com>
 <20130605094225.GC2805@ludovic.desroches@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605094225.GC2805@ludovic.desroches@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5345491283279260524
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:42 Wed 05 Jun     , Ludovic Desroches wrote:
> On Tue, Apr 09, 2013 at 02:45:00PM +0200, Nicolas Ferre wrote:
> > Header file not needed anymore as we have removed
> > the calls to cpu_is_xxx() macro.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Late but of course:
> 
> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> 
> > ---
> >  drivers/mmc/host/atmel-mci.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> > index e75774f..08e2b92 100644
> > --- a/drivers/mmc/host/atmel-mci.c
> > +++ b/drivers/mmc/host/atmel-mci.c
> > @@ -40,8 +40,6 @@
> >  #include <asm/io.h>
> >  #include <asm/unaligned.h>
> >  
> > -#include <mach/cpu.h>
> > -
> >  #include "atmel-mci-regs.h"
> >  
> >  #define ATMCI_DATA_ERROR_FLAGS	(ATMCI_DCRCE | ATMCI_DTOE | ATMCI_OVRE | ATMCI_UNRE)
> > -- 
> > 1.8.0
> > 
