Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab3B0IYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 03:24:05 -0500
Received: from linux-sh.org ([111.68.239.195]:47087 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab3B0IYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 03:24:02 -0500
Date: Wed, 27 Feb 2013 17:23:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, tglx@linutronix.de
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
Message-ID: <20130227082335.GB30395@linux-sh.org>
References: <20130218142834.28739.39417.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130218142834.28739.39417.sendpatchset@w520>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 11:28:34PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> This patch adds a driver for external IRQ pins connected
> to the INTC block on recent SoCs from Renesas.
> 
So how exactly does this interact with the existing sh_intc code? Or is
there some reason why you have opted to bypass it in order to implement a
simplified reduced-functionality version of INTC support focused only on
external pins? If both are used together this is going to be a nightmare
for locking, and it's also non-obvious how the IRQ domains on both sides
will interact.

This needs a lot more explanation.
