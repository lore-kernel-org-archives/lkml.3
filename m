Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaGINTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:19:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:47260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbaGINTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:19:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="570580730"
Message-ID: <1404911964.28592.4.camel@rzhang1-toshiba>
Subject: Re: [RESEND PATCH 0/6] thermal: sti: Add new Thermal driver
From: Zhang Rui <rui.zhang@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, ajitpal.singh@st.com, edubezval@gmail.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Date: Wed, 09 Jul 2014 21:19:24 +0800
In-Reply-To: <20140709120823.GA32573@lee--X1>
References: <1401980819-19962-1-git-send-email-lee.jones@linaro.org>
	 <20140624092309.GD13803@lee--X1> <20140709120823.GA32573@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 13:08 +0100, Lee Jones wrote:
> On Tue, 24 Jun 2014, Lee Jones wrote:
> 
> > > I'm re-sending this set, as one of the maintainers' email addresses
> > > is incorrect in the MAINTAINERS file.
> > > 
> > > This patchset adds full support for 2 types of Thermal Controllers
> > > produced by STMicroelectronics.  One is a more traditional memory
> > > mapped variant, the other is controlled solely by system configuration
> > > registers.
> > 
> > Any thing from the Thermal guys? Has this set fallen through the gaps?
> 
> Anything at all?  It's been well over a month now.
> 
Well, for the soc thermal drivers, I'd prefer to take them via Eduardo,
but as we didn't get any feedback from Eduardo, I will take them.

thanks,
rui
> > >  Documentation/devicetree/bindings/thermal/st-thermal.txt |  42 ++++++++++++++++
> > >  arch/arm/boot/dts/stih416.dtsi                           |  18 +++++++
> > >  arch/arm/configs/multi_v7_defconfig                      |   2 +
> > >  drivers/thermal/Kconfig                                  |   5 ++
> > >  drivers/thermal/Makefile                                 |   1 +
> > >  drivers/thermal/st/Kconfig                               |  12 +++++
> > >  drivers/thermal/st/Makefile                              |   3 ++
> > >  drivers/thermal/st/st_thermal.c                          | 313 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > ++++++++++++++++++++++++++++
> > >  drivers/thermal/st/st_thermal.h                          | 104 ++++++++++++++++++++++++++++++++++++++
> > >  drivers/thermal/st/st_thermal_memmap.c                   | 209 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/thermal/st/st_thermal_syscfg.c                   | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  11 files changed, 888 insertions(+)
> > > 
> > 
> 


