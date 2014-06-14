Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaFNUeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:34:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44859 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaFNUeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:34:21 -0400
Date: Sat, 14 Jun 2014 22:33:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andreas F?rber <afaerber@suse.de>
Cc: Bjorn Andersson <bjorn@kryo.se>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: zImage: Allow DTB to override broken ATAG_MEM
Message-ID: <20140614203356.GD3853@xo-6d-61-c0.localdomain>
References: <1399439776-18535-1-git-send-email-bjorn.andersson@sonymobile.com>
 <20140507080650.GA28564@pengutronix.de>
 <CAJAp7OiVrz+epys3Ko79GmMr6ahv8ii8XphVHE77NSM+wK2mOA@mail.gmail.com>
 <536AA482.8040506@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536AA482.8040506@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-05-07 23:24:18, Andreas F?rber wrote:
> Am 07.05.2014 17:29, schrieb Bjorn Andersson:
> > My problem is that the boot loader on every shipped Qualcomm MSM8x60, MSM8960
> > and APQ8064 based device passes ATAG_MEM with the incorrect start address. There
> > is no way to update the boot loader for these.
> 
> Chaining bootloaders comes to mind. This is being done on the Exynos5
> based Chromebooks, for instance.

You can easily start fixed u-boot from broken u-boot...

But I'm not sure that's the way to go. Perhaps your localised/ugly hack in board
init code is the way to go...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
