Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaGKPCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:02:47 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45156 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751962AbaGKPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:02:45 -0400
Message-ID: <1405090954.32598.60.camel@hornet>
Subject: Re: [PATCH] bus: ARM CCN PMU driver
From: Pawel Moll <pawel.moll@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 11 Jul 2014 16:02:34 +0100
In-Reply-To: <20140711142135.GA21766@n2100.arm.linux.org.uk>
References: <1405088056-29181-1-git-send-email-pawel.moll@arm.com>
	 <20140711142135.GA21766@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 15:21 +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 11, 2014 at 03:14:16PM +0100, Pawel Moll wrote:
> > diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> > index 1f37d98..6ab2a62 100644
> > --- a/drivers/bus/Kconfig
> > +++ b/drivers/bus/Kconfig
> > @@ -4,14 +4,6 @@
> >  
> >  menu "Bus devices"
> >  
> > -config BRCMSTB_GISB_ARB
> > -	bool "Broadcom STB GISB bus arbiter"
> > -	depends on ARM
> > -	help
> > -	  Driver for the Broadcom Set Top Box System-on-a-chip internal bus
> > -	  arbiter. This driver provides timeout and target abort error handling
> > -	  and internal bus master decoding.
> > -
> ...
> > diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
> > index 6a4ea7e..493b4ff 100644
> > --- a/drivers/bus/Makefile
> > +++ b/drivers/bus/Makefile
> > @@ -2,14 +2,15 @@
> >  # Makefile for the bus drivers.
> >  #
> >  
> > -obj-$(CONFIG_BRCMSTB_GISB_ARB)	+= brcmstb_gisb.o
> 
> I assume that as these exist in the patch, you haven't looked through
> the patch to check what you're actually submitting... 

This is, obviously, my bad and lack of attention after last minute
rebase, for which I apologise.

> how can we be
> sure that the rest of the patch is what you intend to submit?

Of course you can't be sure, unless you are willing to take my word for
it. Maybe the fact that 46% of the added lines contains upper- or
lowercase string "CCN" matching the subject can support my plea.

Pawel

