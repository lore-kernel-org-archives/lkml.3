Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3FUK2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:28:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43530 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab3FUK2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:28:05 -0400
Message-ID: <51C42A85.8090705@ti.com>
Date: Fri, 21 Jun 2013 15:57:17 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joel A Fernandes <joelagnel@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v12 00/11] DMA Engine support for AM33XX
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
In-Reply-To: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel,

On 6/21/2013 2:36 AM, Joel A Fernandes wrote:
> From: Joel A Fernandes <agnel.joel@gmail.com>
> 
> This series is remaining of Matt Porter's EDMA patches for AM33XX EDMA support
> with changes for few pending review comments on v11 series.

I have posted a branch with fixes for patches accepted by me in this
series (also posted inline as replies to specific patches).

https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git/log/?h=v3.11/soc-2

Can you please give it a good test - especially on AM335x? I will send a
pull request after you confirm. If you find bugs please send incremental
patches so I can merge into the original patch.

Thanks,
Sekhar
