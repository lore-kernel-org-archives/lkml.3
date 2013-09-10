Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3IJPfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:35:51 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61907 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3IJPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:35:49 -0400
Date: Tue, 10 Sep 2013 16:35:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jic23@cam.ac.uk, Arnd Bergmann <arnd@arndb.de>,
        LinusW <linus.walleij@linaro.org>, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 07/38] ARM: ux500: CONFIG: Enable ST's IIO Accelerometer
 Sensors by default
Message-ID: <20130910153543.GB11227@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-8-git-send-email-lee.jones@linaro.org>
 <CAOesGMj+YzkE5bAxUqFYWoJ-RURDdCK5MUWYTc+gWFQMB3KWkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMj+YzkE5bAxUqFYWoJ-RURDdCK5MUWYTc+gWFQMB3KWkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Olof Johansson wrote:

> On Tue, Sep 10, 2013 at 5:49 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/configs/u8500_defconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
> > index 6b29109..24f88d6 100644
> > --- a/arch/arm/configs/u8500_defconfig
> > +++ b/arch/arm/configs/u8500_defconfig
> > @@ -39,6 +39,7 @@ CONFIG_BLK_DEV_RAM_SIZE=65536
> >  CONFIG_SENSORS_BH1780=y
> >  CONFIG_IIO=y
> >  CONFIG_IIO_ST_PRESS=y
> > +CONFIG_IIO_ST_ACCEL_3AXIS=y
> >  CONFIG_NETDEVICES=y
> >  CONFIG_SMSC911X=y
> >  CONFIG_SMSC_PHY=y
> 
> This is ridiculous.
> 
> I know lwn.net's patch author statistics are fun to be on, but

Jealousy won't get you anywhere... ;)

> splitting this and the other config update into two patches? Really?

I haven't split anything. I created the patches as I was
enabling/testing the drivers, which was at completely different
times. The only reason they're close together in the set is because I
reorganised it and didn't think it was necessary to squash them
together.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
