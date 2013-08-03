Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3HCQKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 12:10:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40095 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3HCQKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 12:10:49 -0400
Date: Sat, 3 Aug 2013 17:10:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/4] ASoc: kirkwood: simplify probe error
Message-ID: <20130803161029.GD23006@n2100.arm.linux.org.uk>
References: <20130731081739.76aae84c@armhf> <20130803123954.GX23006@n2100.arm.linux.org.uk> <20130803175513.7b765b0d@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130803175513.7b765b0d@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 05:55:13PM +0200, Jean-Francois Moine wrote:
> On Sat, 3 Aug 2013 13:39:54 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > This doesn't apply to mainline as there's a clk_put() there.
> 
> Right, it applies to linux-next:
> 
> On Fri, 26 Jul 2013 11:32:50 +0100, Mark Brown <broonie@kernel.org> wrote:
> 
> > Always submit against where the code will be applied - -next in this
> > case.

Sorry, I'm just not going to bother with your patches unless you start
posting them in such a way that interested parties can test them without
having to run around and pull random trees.  In other words, you should
have Cc'd interested parties on that devm_* change patch - especially
myself as I was the one who introduced that code.
