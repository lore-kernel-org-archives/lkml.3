Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaD1Un5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:43:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:60057 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaD1Unz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:43:55 -0400
Date: Mon, 28 Apr 2014 22:44:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Austin Schuh <austin@peloton-tech.com>
cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Sanitize spurious interrupt detection of threaded
 irqs
In-Reply-To: <CANGgnMavy-W8UXosgBrLkSLU=rYvU36OJCE0qgZQ4N6iSdN82A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404282242470.6261@ionos.tec.linutronix.de>
References: <CANGgnMbszHzYe9pF2C6wag4MY_PfBG2qrMCC=rMmQnb-jyXXXw@mail.gmail.com> <52CAB05F.4010303@hartkopp.net> <CANGgnMZZu6tX0LyK4mQaYhixY9uhbQYee7XO5_HtNfT0REPghA@mail.gmail.com> <alpine.DEB.2.02.1404072040320.14882@ionos.tec.linutronix.de>
 <CANGgnMbXSosuUTy02QUuqM2bNomrusJVBN_=f6OE8f+NcAdwmQ@mail.gmail.com> <alpine.DEB.2.02.1404072206550.14882@ionos.tec.linutronix.de> <CANGgnMahGUooVsRLuNd0UyA6bZk1=a_zL+Uqi7AGHrJn1EMxcg@mail.gmail.com>
 <CANGgnMavy-W8UXosgBrLkSLU=rYvU36OJCE0qgZQ4N6iSdN82A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014, Austin Schuh wrote:
> On Mon, Apr 7, 2014 at 1:08 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> > On Mon, Apr 7, 2014 at 1:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> On Mon, 7 Apr 2014, Austin Schuh wrote:
> >>> You originally sent the patch out.  I could send your patch out back
> >>> to you, but that feels a bit weird ;)
> >>
> >> Wheee. Let me dig in my archives ....
> >
> > https://lkml.org/lkml/2013/3/7/222 in case that helps.
> 
> Did you find the patch?  I didn't see anything go by (but I'm not on
> the main mailing list and didn't find anything with a quick Google
> search.)  It would be nice to not need to run a custom kernel to keep
> my machine running.  I have what is probably a year split between 2
> machines of runtime with the patch applied, and I haven't seen any
> problems with it.

It's on my list, but Easter and traveling did not really help :)

There are a few issues with the patch I need to think through, but
I'll get to it in the next few days.
