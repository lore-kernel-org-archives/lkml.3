Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3B1GVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:21:36 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:65114 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3B1GVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:21:35 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6tyDrOF1eNNjY0j4tctx=C+m+9xkjGUFRW33hU+k6+o-g@mail.gmail.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
	<CAAVeFuLP0KLVL-0SS+nGWSoK1RMPCmKgZV-OjMJo-h7E1UVuXw@mail.gmail.com>
	<20130226175311.D17173E2EF8@localhost>
	<CAAVeFuLazaZEbbUVtR_Zyub3hgTesW6JcD9Kxgk7dUXuESpLOw@mail.gmail.com>
	<CACxGe6tyDrOF1eNNjY0j4tctx=C+m+9xkjGUFRW33hU+k6+o-g@mail.gmail.com>
Date: Thu, 28 Feb 2013 07:21:34 +0100
Message-ID: <CACRpkdaxMTHrabKawsufTBYVRW08YBa+hOBb12AVEzXHyox7_Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] gpiolib: some fixup patches
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alexandre Courbot <gnurou@gmail.com>, Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 8:52 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

> I've been playing with an idea of pulling in some basic MMIO gpio
> access directly into gpiolib so that when appropriate gpiolib itself
> can have a fast path for doing the register access and shadow register
> management.

Shadow registers: isn't that what regmap usually does? Or
what are you referring to here?

But fastpath MMIO in the gpiolib is an appealing thought,
given that this was a design impetus in the early history of
the subsystem.

Yours,
Linus Walleij
