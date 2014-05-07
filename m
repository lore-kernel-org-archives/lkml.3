Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbaEGPhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:37:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39457 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaEGPhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:37:14 -0400
Date: Wed, 7 May 2014 17:37:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Len Brown <len.brown@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sricharan R <r.sricharan@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
Message-ID: <20140507153713.GA23775@amd.pavel.ucw.cz>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
 <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
 <20140416101243.GA6952@n2100.arm.linux.org.uk>
 <CADHgK6vyWU1HCueN=F5D0JxzknV==h-jOG9JmcXeOrH_RGV4JQ@mail.gmail.com>
 <CADHgK6v43=KSpe2FRG374nbHSMOt9hb+xEhO7z20vhEAQsx0tQ@mail.gmail.com>
 <CADHgK6tg=7JpYgc0LBmpQzJS-TjK5v_0FQeKRxuFNTqy=QSQzA@mail.gmail.com>
 <CADHgK6uCQT2iAfL+oQvwN7f65u4musKP-AX-E6j1i2OL6ZMJwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADHgK6uCQT2iAfL+oQvwN7f65u4musKP-AX-E6j1i2OL6ZMJwA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-04-23 09:39:48, Sebastian Capella wrote:
> Hi Russell,
> 
> Ran this overnight and no failures on >1000 hibernations.

Congratulations. Looking forward to hibernate n900 on battery low :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
