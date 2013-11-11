Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab3KKKIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:08:54 -0500
Received: from smtp-66.nebula.fi ([83.145.220.66]:58043 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752730Ab3KKKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:08:50 -0500
Date: Mon, 11 Nov 2013 12:08:44 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Subject: Re: [PATCH] video: add OpenCores VGA/LCD framebuffer driver
Message-ID: <20131111100843.GA20337@chokladfabriken.org>
References: <1384088894-31920-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <52809FAA.6080107@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52809FAA.6080107@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 10:13:14AM +0100, Michal Simek wrote:
> On 11/10/2013 02:08 PM, Stefan Kristiansson wrote:
> > +config FB_OPENCORES
> > +	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
> > +	depends on FB
> > +	select FB_CFB_FILLRECT
> > +	select FB_CFB_COPYAREA
> > +	select FB_CFB_IMAGEBLIT
> > +	default n
> > +	help
> > +	  This enables support for the OpenCores VGA/LCD core.
> > +
> > +	  The OpenCores VGA/LCD core is typically used together with
> > +	  softcore CPUs (e.g. OpenRISC) or hard processor systems
> 
> I expect that here can be also Microblaze.

Yes, as would LM32, NiosII etc.
But, since none of those exists in the mainline kernel,
I suppose Microblaze along with OpenRISC is a sensible subset of examples.
I'll add that.

> 
> > +	  (e.g. Altera socfpga or Xilinx Zync) on FPGAs.
> 
> s/Zync/Zynq/
> 

Right, sorry. I'll fix that.

Stefan
