Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaDGSkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:40:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:53207 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaDGSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:40:53 -0400
Date: Mon, 7 Apr 2014 20:41:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Austin Schuh <austin@peloton-tech.com>
cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Sanitize spurious interrupt detection of threaded
 irqs
In-Reply-To: <CANGgnMZZu6tX0LyK4mQaYhixY9uhbQYee7XO5_HtNfT0REPghA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404072040320.14882@ionos.tec.linutronix.de>
References: <CANGgnMbszHzYe9pF2C6wag4MY_PfBG2qrMCC=rMmQnb-jyXXXw@mail.gmail.com> <52CAB05F.4010303@hartkopp.net> <CANGgnMZZu6tX0LyK4mQaYhixY9uhbQYee7XO5_HtNfT0REPghA@mail.gmail.com>
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

> Hi Thomas,
> 
> Did anything come of this patch?  Both Oliver and I have found that it
> fixes real problems.  I have multiple machines which have been running
> with the patch since December with no ill effects.

No, sorry. It fell through the cracks. Care to resend ?

Thanks,

	tglx
