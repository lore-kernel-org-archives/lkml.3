Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3CZUiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:38:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:59002 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3CZUiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:38:00 -0400
Date: Tue, 26 Mar 2013 21:37:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@linuxfoundation.org>
cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Guinot <sguinot@lacie.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3b 0/9] refactoring for mask_cache
In-Reply-To: <20130321215709.GA27612@kroah.com>
Message-ID: <alpine.LFD.2.02.1303262136350.22263@ionos>
References: <1363885931-20571-1-git-send-email-gerlando.falauto@keymile.com> <20130321215709.GA27612@kroah.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Greg KH wrote:

> On Thu, Mar 21, 2013 at 06:12:02PM +0100, Gerlando Falauto wrote:
> > This patchset addresses a regression found with the Orion GPIO controller
> > when both Edge- and Level- based interrupts are requested within the same
> > GPIO chip. The regression was introduced by e59347a
> > "arm: orion: Use generic irq chip"
> > 
> > thereby affecting all kernel releases since 3.0.x.
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

Aside of that it would be less intrusive for the stable series to
revert the offending commit(s), if that is possible.

Thanks,

	tglx



