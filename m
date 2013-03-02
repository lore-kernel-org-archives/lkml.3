Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3CCMIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:08:47 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:50768 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3CCMHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:07:51 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] gpio: Add device driver for GRGPIO cores and support custom accessors with gpio-generic
To: Linus Walleij <linus.walleij@linaro.org>,
        Andreas Larsson <andreas@gaisler.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
In-Reply-To: <CACRpkdaYQSrzm_Yj3ZH9YZLC_zPJN06X-9ZM9jd7=X0OB1shXQ@mail.gmail.com>
References: <1360653873-25368-1-git-send-email-andreas@gaisler.com> <CACRpkdaYQSrzm_Yj3ZH9YZLC_zPJN06X-9ZM9jd7=X0OB1shXQ@mail.gmail.com>
Date: Sat, 02 Mar 2013 20:13:02 +0000
Message-Id: <20130302201302.E16FE3E219B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013 01:24:01 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Feb 12, 2013 at 8:24 AM, Andreas Larsson <andreas@gaisler.com> wrote:
> 
> > This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP
> > core library from Aeroflex Gaisler.
> >
> > This also adds support to gpio-generic for using custom accessor
> > functions. The grgpio driver uses this to use ioread32be and iowrite32be
> > for big endian register accesses.
> >
> > Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> 
> Can you split this in two patches: one that adds the custom accessors
> and one that adds the driver?

Yes please, and as commented on in the other thread you can go ahead and
add the BE accessors to gpio-generic.c. I would like to optimize things
in gpiolib to make a lot of gpio-generic.c unnecessary, but that is only
an idea at this point.

g.
