Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaKMJyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:54:21 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37786 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932074AbaKMJyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:54:18 -0500
Date: Thu, 13 Nov 2014 10:54:14 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: remove CONFIG_MACH_SAMA5_DT
Message-ID: <20141113095413.GA28756@piout.net>
References: <1415652353-15985-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20141113103425.1cf5e8ea@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113103425.1cf5e8ea@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/2014 at 10:34:25 +0100, Boris Brezillon wrote :
> > diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> > index 0e6d548b70d9..81ddd7d31d1e 100644
> > --- a/arch/arm/mach-at91/Kconfig
> > +++ b/arch/arm/mach-at91/Kconfig
> > @@ -58,6 +58,7 @@ config SOC_SAMA5
> >  	select USE_OF
> >  	select MEMORY
> >  	select ATMEL_SDRAMC
> > +	select PHYLIB if NETDEVICES
> 
> Is this really related to this commit ?
> 

Yes, I simply moved it from CONFIG_MACH_SAMA5_DT to CONFIG_SOC_SAMA5 to
keep the same functionalities (and probably avoid compilation breakage).


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
