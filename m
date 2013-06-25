Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3FYOMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:12:16 -0400
Received: from mail.abilis.ch ([195.70.19.74]:14738 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3FYOMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:12:14 -0400
Date: Tue, 25 Jun 2013 16:11:43 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver
Message-ID: <20130625141141.GA1720@ab42.lan>
References: <20130530211944.05F4D3E0A90@localhost>
 <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com>
 <alpine.DEB.2.02.1306251551020.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.02.1306251551020.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 03:58:43PM +0200, Thomas Gleixner wrote:
> On Fri, 31 May 2013, Christian Ruppert wrote:
> > The SOC interrupt controller driver for the Abilis Systems TB10x series of
> > SOCs based on ARC700 CPUs.
> > 
> > This patch depends on commits eb76bdd407d8a90e59a06cb0158886df390e5d1c and
> > 712bc93df9e7f14b8a163148d2aa7c778e151627 from branch irq/for-arm of
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git.
> 
> This should go below --- as it is not part of the changelog.

OK, I will change that.

> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> 
> Why is Pierrick in the SOB chain? 

We work on the platform port together and review and test each others'
patches. It is planned submitting several of his patches as soon as
basic platform is in.

> > ---
> >  .../interrupt-controller/abilis,tb10x-ictl.txt     |   38 ++++
> >  arch/arc/boot/dts/abilis_tb100.dtsi                |   32 ++--
> >  arch/arc/boot/dts/abilis_tb101.dtsi                |   32 ++--
> >  arch/arc/boot/dts/abilis_tb10x.dtsi                |   32 ++--
> >  arch/arc/plat-tb10x/Kconfig                        |    1 +
> >  drivers/irqchip/Kconfig                            |    5 +
> >  drivers/irqchip/Makefile                           |    1 +
> >  drivers/irqchip/irq-tb10x.c                        |  195 ++++++++++++++++++++
> 
> I can pick it up, but I'm not so fond of carrying arch/arc patches
> which might conflict with other stuff in the arc tree. Veenet, if I
> should pick the whole thing up, I'd like to have an acked-by at least.

Would you prefer if we separated everything in arch/arc from this patch
and push it through Vineet's channel?

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
