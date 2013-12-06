Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3LFQYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:24:40 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44491 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3LFQYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:24:37 -0500
Date: Fri, 6 Dec 2013 16:24:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Milo Kim <milo.kim@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Message-ID: <20131206162432.GA11060@lee--X1>
References: <1380082975-6022-1-git-send-email-milo.kim@ti.com>
 <20131204103431.GC26589@ulmo.nvidia.com>
 <20131205214341.GC29268@sirena.org.uk>
 <20131206132405.GC30960@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131206132405.GC30960@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Dec 2013, Thierry Reding wrote:

> On Thu, Dec 05, 2013 at 09:43:41PM +0000, Mark Brown wrote:
> > On Wed, Dec 04, 2013 at 11:34:32AM +0100, Thierry Reding wrote:
> > > On Wed, Sep 25, 2013 at 01:22:55PM +0900, Milo Kim wrote:
> > 
> > > >   mfd: add LP3943 MFD driver
> > > >   gpio: add LP3943 I2C GPIO expander driver
> > > >   pwm: add LP3943 PWM driver
> > > >   Documentation: add LP3943 DT bindings and document
> > 
> > > I suspect that given the build-time dependencies Lee may want to take
> > > all four patches through the MFD tree, so I've acked the PWM parts.
> > 
> > FWIW this isn't an issue with new MFDs - since the function drivers will
> > depend on the core driver it's not possible to enable them in Kconfig
> > until the core driver is also merged and you don't get bisect issues.
> 
> Right. I hadn't thought about that. Thanks for mentioning it.

I have applied them all with the relevant Acks in any case.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
