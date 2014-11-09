Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaKIRY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 12:24:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaKIRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 12:24:27 -0500
Date: Sun, 9 Nov 2014 09:23:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: Scott Branden <sbranden@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 4/8] ARM: dts: Enable Broadcom Cygnus SoC
Message-ID: <20141109172311.GB738@kroah.com>
References: <sbranden@broadcom.com>
 <1414525992-3678-1-git-send-email-sbranden@broadcom.com>
 <1414525992-3678-5-git-send-email-sbranden@broadcom.com>
 <CAOesGMjUE-Z3L=FU1nspv5M52UhhJ9-dBLr40RTCz2WEhEPHLA@mail.gmail.com>
 <545F05F0.3000702@broadcom.com>
 <CAOesGMhd37UM+7+6eR9iLY22Fb9cG1dr8dD4DAzLJNRmtysnkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhd37UM+7+6eR9iLY22Fb9cG1dr8dD4DAzLJNRmtysnkg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 10:49:09PM -0800, Olof Johansson wrote:
> >>> +/*
> >>> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
> >>> + *
> >>> + * Unless you and Broadcom execute a separate written software license
> >>> + * agreement governing use of this software, this software is licensed
> >>> to you
> >>> + * under the terms of the GNU General Public License as
> >>> + * published by the Free Software Foundation version 2.
> >>> + *
> >>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> >>> + * kind, whether express or implied; without even the implied warranty
> >>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>> + * GNU General Public License for more details.
> >>
> >>
> >> We ask for new DT contents to be added with dual BSD/GPL license, to
> >> allow for reuse of the DT data structures in other projects as well.
> >> There's currently a lot of activity going on relicensing the current
> >> files so I recommend sorting it out before they are added if you can.
> >
> >
> > This may take more time than you think.  I am going to have to go through
> > legal to get such a license created. Also, why would you need dual license?
> > If it is BSD that should serve both purposes?
> 
> I haven't followed the discussion close enough to know if there's been
> discussion about single-license BSD vs dual BSD/GPL.
> 
> At the very least, please start the process of getting it changed.
> 
> Also, I see now that this isn't even a clean GPL v2, given "Unless you
> and Broadcom..." language. I see the bnx2x driver had that in the
> past, but none of the Kona contributions did. I strongly suggest
> sticking to the normal copyrights here and not making things more
> complicated than they have to.

I'm thinking that the "unless you and Broadcom..." language really
doesn't mean much other than what all other files in the kernel mean
from what I can tell.  This should just default to GPLv2 and everyone
should be ok.

But note, I'm not a lawyer, it would be good to get a confirmation from
Broadcom that this is the exact wording they want in this file, and that
they are happy with it being "just" GPLv2 for all intensive purposes, as
it does "differ" from the wording we are "accustomed" to seeing in
kernel files.

thanks,

greg k-h
