Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbaAFVbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:31:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51349 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaAFVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:31:37 -0500
Date: Mon, 6 Jan 2014 22:31:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: rui.zhang@intel.com, Mike Turquette <mturquette@linaro.org>,
        Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC RESEND PATCH 1/1] thermal: introduce clock cooling device
Message-ID: <20140106213135.GA14927@amd.pavel.ucw.cz>
References: <1389013458-14719-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389013458-14719-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- /dev/null
> +++ b/drivers/thermal/clock_cooling.c
> @@ -0,0 +1,484 @@
> +/*
> + *  drivers/thermal/cpu_cooling.c

Bit too much copy&paste...


> + *  Copyright (C) 2013	Texas Instruments Inc.
> + *  Contact:  Eduardo Valentin <eduardo.valentin@ti.com>
> + *
> + *  Highly based on cpu_cooling.c.

Check english. And you should add samsung & linaro copyright here,
since you copied from it.

> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

can we get rid of ~~~s?

> +static int clock_cooling_get_property(struct clock_cooling_device *ccdev,
> +				      unsigned long input,
> +				      unsigned long *output,
> +				      enum clock_cooling_property property)
> +{
> +	int i, j;
> +	unsigned long max_level = 0, level = 0;
...
> +	if (property == GET_MAXL) {
> +		*output = (unsigned int)max_level;

What is going on with types here? Remove cast?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
