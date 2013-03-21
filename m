Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab3CUV5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:57:18 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38829 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3CUV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:57:14 -0400
Date: Thu, 21 Mar 2013 14:57:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Simon Guinot <sguinot@lacie.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3b 0/9] refactoring for mask_cache
Message-ID: <20130321215709.GA27612@kroah.com>
References: <1363885931-20571-1-git-send-email-gerlando.falauto@keymile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363885931-20571-1-git-send-email-gerlando.falauto@keymile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 06:12:02PM +0100, Gerlando Falauto wrote:
> This patchset addresses a regression found with the Orion GPIO controller
> when both Edge- and Level- based interrupts are requested within the same
> GPIO chip. The regression was introduced by e59347a
> "arm: orion: Use generic irq chip"
> 
> thereby affecting all kernel releases since 3.0.x.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
