Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936880Ab3DIIPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:15:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:49599 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935136Ab3DIIPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:15:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="319575338"
Date: Tue, 9 Apr 2013 10:14:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: remove twelve unused Kconfig symbols
Message-ID: <20130409081440.GI24058@zurbaran>
References: <1363732701.1390.45.camel@x61.thuisdomein>
 <20130320082427.GB28775@opensource.wolfsonmicro.com>
 <1363770579.1390.82.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363770579.1390.82.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Mar 20, 2013 at 10:09:39AM +0100, Paul Bolle wrote:
> Twelve Kconfig symbols, all related to WM8350, WM8351, and WM8352, are
> unused. Commit 19d57ed5a308472a02e773f33c03ad4cb2ec6a9 ("mfd: Remove
> custom wm8350 cache implementation") removed all their (actual) users.
> Remove these symbols too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 0) This version adds Mark's ACK. It is now also sent to the ARM
> maintainers, as Mark suggested.
> 
> 1) Still only eyeball tested.
> 
>  arch/arm/mach-imx/Kconfig     |  2 --
>  arch/arm/mach-s3c64xx/Kconfig |  3 ---
>  drivers/mfd/Kconfig           | 48 -------------------------------------------
>  3 files changed, 53 deletions(-)
Applied to my mfd-next tree, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
