Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbaD3O3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:29:31 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:35675 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160AbaD3O33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:29:29 -0400
Date: Wed, 30 Apr 2014 15:29:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 02/10] mfd: vexpress: Convert custom func API to regmap
Message-ID: <20140430142922.GU29462@lee--X1>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
 <1398707877-22596-3-git-send-email-pawel.moll@arm.com>
 <20140430135855.GO29462@lee--X1>
 <1398867224.24255.22.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398867224.24255.22.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > MFD diffstat looks great and the changes look sensible:
> >   Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> Thanks!
> 
> > I guess someone will need to create a branch for us all to pull from.
> > I'm happy to do it if needs be.
> 
> I was thinking that, with enough acks (and I'm counting on one from you
> for "[PATCH 04/10] mfd: vexpress: Define the device as MFD cells" :-),

That won't happen right away - it's another 500+ line patch and
contary to popular believe I do have my own work to contend with too.

> merging the whole series (or at least patches 1-4 and 7-8) through
> arm-soc tree would be the simplest option. I have no problem with the
> independent bits (clk, clocksource, hwmon and the mfd/HBI change) going
> through appropriate subsystems.

I have no problem with that as long as one of the ARM-SoC guys can
provide a branch where the other subsystems can pull from.  If they
have no time, my offer still stands.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
