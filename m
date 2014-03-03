Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaCCOq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:46:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:44923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbaCCOqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:46:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,577,1389772800"; 
   d="scan'208";a="465525262"
Message-ID: <1393857979.2193.27.camel@rzhang1-mobl4>
Subject: Re: [PATCH 2/2] thermal,rcar_thermal: Add dependency on HAS_IOMEM
From: Zhang Rui <rui.zhang@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, eduardo.valentin@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        horms@verge.net.au, laurent.pinchart+renesas@ideasonboard.com
Date: Mon, 03 Mar 2014 22:46:19 +0800
In-Reply-To: <87k3cf8tyt.wl%kuninori.morimoto.gx@gmail.com>
References: <1390688954-4940-1-git-send-email-richard@nod.at>
	 <1393484282.2637.17.camel@rzhang1-mobl4>
	 <87fvn4yskv.wl%kuninori.morimoto.gx@gmail.com> <5310470D.6000404@nod.at>
	 <87k3cf8tyt.wl%kuninori.morimoto.gx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 01:30 -0800, Kuninori Morimoto wrote:
> Hi Richard, Zhang
> 
> > >>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > >>> index 35c0664..88efa8f 100644
> > >>> --- a/drivers/thermal/Kconfig
> > >>> +++ b/drivers/thermal/Kconfig
> > >>> @@ -136,6 +136,7 @@ config SPEAR_THERMAL
> > >>>  config RCAR_THERMAL
> > >>>  	tristate "Renesas R-Car thermal driver"
> > >>>  	depends on ARCH_SHMOBILE || COMPILE_TEST
> > >>> +	depends on HAS_IO_MEM
> > >>>  	help
> > >>>  	  Enable this to plug the R-Car thermal sensor driver into the Linux
> > >>>  	  thermal framework.
> > > 
> > > I guess
> > > 
> > >  - HAS_IO_MEM
> > >  + HAS_IOMEM
> > 
> > Yeah, this has been resolved in v2:
> > https://lkml.org/lkml/2014/1/27/59
> 
> Nice !
> 
> Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 

applied.

thanks,
rui


