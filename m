Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3IPHb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:31:57 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41894 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3IPHbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:31:55 -0400
Date: Mon, 16 Sep 2013 08:31:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 38/38] iio: magn-core: st: Provide support for the
 LSM303DLH
Message-ID: <20130916073151.GB3999@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-39-git-send-email-lee.jones@linaro.org>
 <5234A28D.1030409@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5234A28D.1030409@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Sep 2013, Jonathan Cameron wrote:

> On 09/10/13 13:49, Lee Jones wrote:
> > Trivial patch adding the LSM303DLH to the list of already supported
> > Magnetometer Sensors.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> err.

?

> > index 12e7e79..b2e2917 100644
> > --- a/drivers/iio/magnetometer/st_magn_core.c
> > +++ b/drivers/iio/magnetometer/st_magn_core.c
> > @@ -151,7 +151,8 @@ static const struct st_sensors st_magn_sensors[] = {
> >  		.wai = ST_MAGN_1_WAI_EXP,
> >  		.sensors_supported = {
> >  			[0] = LSM303DLHC_MAGN_DEV_NAME,
> > -			[1] = LSM303DLM_MAGN_DEV_NAME,
> > +			[1] = LSM303DLH_MAGN_DEV_NAME,
> > +			[0] = LSM303DLM_MAGN_DEV_NAME,
> [2]?

Yes, good spot, thanks.

> >  		},
> >  		.ch = (struct iio_chan_spec *)st_magn_16bit_channels,
> >  		.odr = {
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
