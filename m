Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3C1GPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:15:33 -0400
Received: from norkia.v3.sk ([91.210.183.14]:46088 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab3C1GPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:15:31 -0400
Subject: Re: [PATCH] hw_random: Add Broadcom BCM2835 RNG Driver
From: Lubomir Rintel <lkundrak@v3.sk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
In-Reply-To: <514D1719.501@wwwdotorg.org>
References: <1363956930-5717-1-git-send-email-lkundrak@v3.sk>
	 <514D1719.501@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Mar 2013 07:15:27 +0100
Message-ID: <1364451327.4324.1.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 20:44 -0600, Stephen Warren wrote:
> On 03/22/2013 06:55 AM, Lubomir Rintel wrote:
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> 
> A commit description would be useful.
> 
> >  arch/arm/boot/dts/bcm2835.dtsi       |    5 +
> >  arch/arm/configs/bcm2835_defconfig   |    3 +-
> >  drivers/char/hw_random/Kconfig       |   12 +++
> >  drivers/char/hw_random/Makefile      |    1 +
> >  drivers/char/hw_random/bcm2835-rng.c |  137 ++++++++++++++++++++++++++++++++++
> 
> This should be split into 3 separate patches: (1) The driver itself, (2)
> the change to bcm2835.dtsi, and (3) the change to bcm2835_defconfig.
> 
> Since you're adding a new device to device tree for the first time, you
> should write a binding document for it; most likely
> Documentation/devicetree/bindings/rng/brcm,bcm2835.txt (or perhaps
> /random/ rather than /rng/?)
> 
> Is this driver based on the downstream Raspberry Pi kernel's driver? If
> so, some mention of that fact would be appropriate in the commit
> description, or even the git author field. I note that in the downstream
> kernel, the commit which adds the RNG driver isn't signed off at all.
> This probably means you need to get Dom to add his signed-off-by line
> for that commit before basing your work on it. See
> Documentation/SubmittingPatches for more details.

Got this message, will follow up with updated patch:

On Wed, 2013-03-27 at 18:22 +0000, popcornmix wrote:
On Wed, Mar 27, 2013 at 4:55 PM, Lubomir Rintel <lkundrak@v3.sk> wrote:
> > Hi!
> >
> > I'm currently in the process of mainlining the drivers from
Raspberry Pi
> > tree. I was asked for a signoff for the random number generator. It
> > seems to have been commit by you in the downstream tree, I'm
wondering
> > if you could help me, and respond with a Signed-off-by tag if the
code
> > comes from you, or point me to someone else?
> >
> > commit e95a8204d7f8fc4f38900c99080103254c3cef11
> > Author: popcornmix <popcornmix@gmail.com>
> > Date:   Wed Jan 30 11:44:26 2013 +0000
> >
> >     Add hwrng (hardware random number generator) driver
> >
> > Thank you!
> > --
> > Lubomir Rintel <lkundrak@v3.sk>
> >
> 
> Sorry, I'm not up to speed with exactly what constitutes a sign off.
> I did write the original hw-rng driver, and give my permission for it
> to be upstreamed.
> Is this sufficient?
>  Signed-off-by: Dom Cobley <dc4@broadcom.com>
>  Signed-off-by: Dom Cobley <popcornmix@gmail.com>
>  Signed-off-by: popcornmix <popcornmix@gmail.com>
> 
> (not sure which is more suitable - they are all me).

-- 
Lubomir Rintel (ext. #7715)
GoodData Code Feng Shui Critic

