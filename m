Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaDGUHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:07:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:53451 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaDGUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:07:06 -0400
Date: Mon, 7 Apr 2014 22:07:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Austin Schuh <austin@peloton-tech.com>
cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Sanitize spurious interrupt detection of threaded
 irqs
In-Reply-To: <CANGgnMbXSosuUTy02QUuqM2bNomrusJVBN_=f6OE8f+NcAdwmQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404072206550.14882@ionos.tec.linutronix.de>
References: <CANGgnMbszHzYe9pF2C6wag4MY_PfBG2qrMCC=rMmQnb-jyXXXw@mail.gmail.com> <52CAB05F.4010303@hartkopp.net> <CANGgnMZZu6tX0LyK4mQaYhixY9uhbQYee7XO5_HtNfT0REPghA@mail.gmail.com> <alpine.DEB.2.02.1404072040320.14882@ionos.tec.linutronix.de>
 <CANGgnMbXSosuUTy02QUuqM2bNomrusJVBN_=f6OE8f+NcAdwmQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014, Austin Schuh wrote:

> On Mon, Apr 7, 2014 at 11:41 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 7 Apr 2014, Austin Schuh wrote:
> >
> >> Hi Thomas,
> >>
> >> Did anything come of this patch?  Both Oliver and I have found that it
> >> fixes real problems.  I have multiple machines which have been running
> >> with the patch since December with no ill effects.
> >
> > No, sorry. It fell through the cracks. Care to resend ?
> >
> > Thanks,
> >
> >         tglx
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-can" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> You originally sent the patch out.  I could send your patch out back
> to you, but that feels a bit weird ;)

Wheee. Let me dig in my archives ....
