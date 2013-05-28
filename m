Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab3E1Clm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 22:41:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:28334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630Ab3E1Cll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 22:41:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,755,1363158000"; 
   d="scan'208";a="344246626"
Message-ID: <1369708896.1913.5.camel@rzhang1-mobl4>
Subject: Re: [PATCH 0/2] staging -> thermal: move ti-soc-thermal to
 drivers/thermal
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Tue, 28 May 2013 10:41:36 +0800
In-Reply-To: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
References: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 11:45 -0400, Eduardo Valentin wrote:
> Hello Greg and Rui,
> 
> I am proposing to move the ti-soc-thermal driver from drivers/stating/
> to drivers/thermal. It has been some time that we have been fixing and
> improving the code under staging tree.
> 
> I believe it is time to move on. The driver now has a better code
> organization (split between code and data), DT support, better coding
> style, it supports TI OMAP chips 4430, 4460, 4470 and 5430, and it is
> ready for easy addition of other SoC chips containing the bandgap IP.
> Besides, this driver required some major changes in the thermal framework,
> before it could provide basic functionality using the device capability.
> These changes have been already merged in previous merge windows,
> so there is no pending dependencies.
> 
> The remaining items in the TODO list are actually not a blocker for this
> move, IMO. The PM support is not fully completed on all supported OMAP chips.
> The locking so far has not caused any issues, and I believe that most of
> the interesting data is protected by the thermal framework.
> 
> I am sending this patch for your appreciation and also to get wider review.
> 

patch applied to thermal -next tree and targeted for 3.11.

thanks,
rui
> All best,
> 
> Eduardo Valentin (2):
>   thermal: introduce TI SoC thermal driver
>   MAINTAINERS: update TI SoC thermal driver entry
> 
>  .../devicetree/bindings/thermal}/ti_soc_thermal.txt                   | 0
>  MAINTAINERS                                                           | 4 ++--
>  drivers/staging/Kconfig                                               | 2 --
>  drivers/staging/Makefile                                              | 1 -
>  drivers/thermal/Kconfig                                               | 3 +++
>  drivers/thermal/Makefile                                              | 2 +-
>  drivers/{staging => thermal}/ti-soc-thermal/Kconfig                   | 0
>  drivers/{staging => thermal}/ti-soc-thermal/Makefile                  | 0
>  drivers/{staging => thermal}/ti-soc-thermal/TODO                      | 0
>  drivers/{staging => thermal}/ti-soc-thermal/omap4-thermal-data.c      | 0
>  drivers/{staging => thermal}/ti-soc-thermal/omap4xxx-bandgap.h        | 0
>  drivers/{staging => thermal}/ti-soc-thermal/omap5-thermal-data.c      | 0
>  drivers/{staging => thermal}/ti-soc-thermal/omap5xxx-bandgap.h        | 0
>  drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.c              | 0
>  drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.h              | 0
>  drivers/{staging => thermal}/ti-soc-thermal/ti-thermal-common.c       | 0
>  drivers/{staging => thermal}/ti-soc-thermal/ti-thermal.h              | 0
>  17 files changed, 6 insertions(+), 6 deletions(-)
>  rename {drivers/staging/ti-soc-thermal => Documentation/devicetree/bindings/thermal}/ti_soc_thermal.txt (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/Kconfig (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/Makefile (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/TODO (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/omap4-thermal-data.c (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/omap4xxx-bandgap.h (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/omap5-thermal-data.c (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/omap5xxx-bandgap.h (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.c (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.h (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/ti-thermal-common.c (100%)
>  rename drivers/{staging => thermal}/ti-soc-thermal/ti-thermal.h (100%)
> 


