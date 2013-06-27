Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3F0ICo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:02:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:17602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab3F0ICk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:02:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="360351084"
Date: Thu, 27 Jun 2013 10:01:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v3 0/3] regulator: max8998: Add support for Device Tree
Message-ID: <20130627080138.GC4576@zurbaran>
References: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Mon, Jun 24, 2013 at 02:39:51PM +0200, Tomasz Figa wrote:
> This series adds Device Tree support to max8998 MFD driver.
> 
> First patch reworks max8998-irq driver to use IRQ domains. Second patch
> prepares platform data structure to ease generating it at runtime from
> data parsed from device tree. Third patch implements Device Tree
> binding and adds necessary documentation.
> 
> Tested on Universal C210 board.
> 
> Changes since v2:
>  - switched to simple domains to retain compatibility with platforms
>    that do not support Device Tree
>  - removed clocks from DT regulator bindings (will be moved to common
>    clock framework in further patch)
>  - beautified the code a bit
> Changes since v1:
>  - rebased to current for-next of regulator tree
> 
> Tomasz Figa (3):
>   mfd: Add irq domain support for max8998 interrupts
>   regulator: max8998: Use arrays for specifying voltages in platform
>     data
>   mfd: max8998: Add support for Device Tree
> 
>  Documentation/devicetree/bindings/mfd/max8998.txt | 108 ++++++++++
>  arch/arm/mach-exynos/mach-universal_c210.c        |   8 +-
>  arch/arm/mach-s5pv210/mach-aquila.c               |   8 +-
>  arch/arm/mach-s5pv210/mach-goni.c                 |   8 +-
>  drivers/mfd/Kconfig                               |   1 +
>  drivers/mfd/max8998-irq.c                         |  65 +++---
>  drivers/mfd/max8998.c                             |  75 ++++++-
>  drivers/regulator/max8998.c                       | 239 +++++++++++++++-------
>  drivers/rtc/rtc-max8998.c                         |  14 +-
>  include/linux/mfd/max8998-private.h               |   7 +-
>  include/linux/mfd/max8998.h                       |  20 +-
>  11 files changed, 421 insertions(+), 132 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max8998.txt
All 3 patches applied, thanks.
Mark, I added your ACK to patch #2.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
