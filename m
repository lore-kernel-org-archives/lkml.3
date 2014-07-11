Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaGKOWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:22:17 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35524 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754893AbaGKOWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:22:14 -0400
Date: Fri, 11 Jul 2014 15:21:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] bus: ARM CCN PMU driver
Message-ID: <20140711142135.GA21766@n2100.arm.linux.org.uk>
References: <1405088056-29181-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405088056-29181-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:14:16PM +0100, Pawel Moll wrote:
> diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> index 1f37d98..6ab2a62 100644
> --- a/drivers/bus/Kconfig
> +++ b/drivers/bus/Kconfig
> @@ -4,14 +4,6 @@
>  
>  menu "Bus devices"
>  
> -config BRCMSTB_GISB_ARB
> -	bool "Broadcom STB GISB bus arbiter"
> -	depends on ARM
> -	help
> -	  Driver for the Broadcom Set Top Box System-on-a-chip internal bus
> -	  arbiter. This driver provides timeout and target abort error handling
> -	  and internal bus master decoding.
> -
...
> diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
> index 6a4ea7e..493b4ff 100644
> --- a/drivers/bus/Makefile
> +++ b/drivers/bus/Makefile
> @@ -2,14 +2,15 @@
>  # Makefile for the bus drivers.
>  #
>  
> -obj-$(CONFIG_BRCMSTB_GISB_ARB)	+= brcmstb_gisb.o

I assume that as these exist in the patch, you haven't looked through
the patch to check what you're actually submitting... how can we be
sure that the rest of the patch is what you intend to submit?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
