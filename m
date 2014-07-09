Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaGINqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:46:54 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64358 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaGINqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:46:52 -0400
Date: Wed, 9 Jul 2014 14:46:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, ajitpal.singh@st.com, edubezval@gmail.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Subject: Re: [RESEND PATCH 0/6] thermal: sti: Add new Thermal driver
Message-ID: <20140709134646.GB479@lee--X1>
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
 <20140624092309.GD13803@lee--X1>
 <20140709120823.GA32573@lee--X1>
 <1404911964.28592.4.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404911964.28592.4.camel@rzhang1-toshiba>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2014, Zhang Rui wrote:

> On Wed, 2014-07-09 at 13:08 +0100, Lee Jones wrote:
> > On Tue, 24 Jun 2014, Lee Jones wrote:
> > 
> > > > I'm re-sending this set, as one of the maintainers' email addresses
> > > > is incorrect in the MAINTAINERS file.
> > > > 
> > > > This patchset adds full support for 2 types of Thermal Controllers
> > > > produced by STMicroelectronics.  One is a more traditional memory
> > > > mapped variant, the other is controlled solely by system configuration
> > > > registers.
> > > 
> > > Any thing from the Thermal guys? Has this set fallen through the gaps?
> > 
> > Anything at all?  It's been well over a month now.
> > 
> Well, for the soc thermal drivers, I'd prefer to take them via Eduardo,
> but as we didn't get any feedback from Eduardo, I will take them.

Thanks Rui.

So have you taken all 4 "thermal: sti: *" patches?

The ARM ones should go through Maxime.

> > > >  Documentation/devicetree/bindings/thermal/st-thermal.txt |  42 ++++++++++++++++
> > > >  arch/arm/boot/dts/stih416.dtsi                           |  18 +++++++
> > > >  arch/arm/configs/multi_v7_defconfig                      |   2 +
> > > >  drivers/thermal/Kconfig                                  |   5 ++
> > > >  drivers/thermal/Makefile                                 |   1 +
> > > >  drivers/thermal/st/Kconfig                               |  12 +++++
> > > >  drivers/thermal/st/Makefile                              |   3 ++
> > > >  drivers/thermal/st/st_thermal.c                          | 313 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > > ++++++++++++++++++++++++++++
> > > >  drivers/thermal/st/st_thermal.h                          | 104 ++++++++++++++++++++++++++++++++++++++
> > > >  drivers/thermal/st/st_thermal_memmap.c                   | 209 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  drivers/thermal/st/st_thermal_syscfg.c                   | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  11 files changed, 888 insertions(+)
> > > > 
> > > 
> > 
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
