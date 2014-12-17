Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaLQLye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:54:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43014 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQLyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:54:32 -0500
Date: Wed, 17 Dec 2014 12:54:29 +0100
From: Pavel Machek <pavel@denx.de>
To: atull <atull@opensource.altera.com>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: Michal Simek <michal.simek@xilinx.com>, gregkh@linuxfoundation.org,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, pantelis.antoniou@konsulko.com,
        robh+dt@kernel.org, grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: SPDX for kernel (was Re: [PATCH v4 5/6] staging: fpga manager:
 framework core)
Message-ID: <20141217115429.GA21214@amd>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
 <1418156090-23578-6-git-send-email-atull@opensource.altera.com>
 <049ad99df824432caa190566141d1525@BN1BFFO11FD005.protection.gbl>
 <alpine.DEB.2.02.1412121026480.27443@linuxheads99>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412121026480.27443@linuxheads99>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > @@ -0,0 +1,485 @@
> > > +/*
> > > + * FPGA Manager Core
> > > + *
> > > + *  Copyright (C) 2013-2014 Altera Corporation
> > > + *
> > > + * With code from the mailing list:
> > > + * Copyright (C) 2013 Xilinx, Inc.
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify it
> > > + * under the terms and conditions of the GNU General Public License,
> > > + * version 2, as published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope it will be useful, but WITHOUT
> > > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > > + * more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License along with
> > > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > > + */
> > 
> > Greg, Grant: What about to use just SPDX?
> > 
> > SPDX-License-Identifier:     GPL-2.0
> 
> This is a standared GPLv2 header, we're keeping it.  Our legal dept
> wants it.

This has nothing to do with Altera here, but... SPDX works great for
u-boot and yes, I believe it would be good idea to kernel as well.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
