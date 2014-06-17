Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838AbaFQQVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:21:31 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58122 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687AbaFQQV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:21:27 -0400
Date: Tue, 17 Jun 2014 09:21:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Heiko Schocher <hs@denx.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4] hwmon: Driver for TI TMP103 temperature sensor
Message-ID: <20140617162114.GA23451@roeck-us.net>
References: <1402992713-22711-1-git-send-email-hs@denx.de>
 <20140617161105.GF8930@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617161105.GF8930@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 05:11:05PM +0100, Mark Rutland wrote:
> On Tue, Jun 17, 2014 at 09:11:53AM +0100, Heiko Schocher wrote:
> > Driver for the TI TMP103.
> > 
> > The TI TMP103 is similar to the TMP102.  It differs from the TMP102
> > by having only 8 bit registers.
> > 
> > Signed-off-by: Heiko Schocher <hs@denx.de>
> > 
[ ... ]
> > +
> > +static const struct i2c_device_id tmp103_id[] = {
> > +	{ DRIVER_NAME, 0 },
> 
> This seems to be used for compatible string matching. As such, I think
> it would make more sense to have the string in full here so as to
> discourage it from being changed arbitrarily in future.
> 
Makes sense. Heiko, can you change that as well in v5 ?
It also simplifies adding another chip to the driver, should that
ever happen.

Thanks,
Guenter
