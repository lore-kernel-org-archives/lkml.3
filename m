Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3GQMkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:40:40 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:56289
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754780Ab3GQMke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:40:34 -0400
X-Greylist: delayed 1949 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 08:40:34 EDT
Message-ID: <51E68922.5020503@newflow.co.uk>
Date: Wed, 17 Jul 2013 13:08:02 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
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
Subject: Re: [PATCH v2] ARM: dts: add AM33XX MMC support
References: <1372303956-30208-1-git-send-email-joelf@ti.com>
In-Reply-To: <1372303956-30208-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/13 04:32, Joel Fernandes wrote:
> From: Matt Porter <mporter@ti.com>
> 
> Adds AM33XX MMC support for am335x-bone, am335x-evm, and am335x-evmsk.
> Also added is the DMA binding definitions based on the generic DMA
> request binding.
> 
> The HWMOD data removal was breaking MMC so some new properties like reg,
> interrupt etc were added.
> 
> Changes to DTS:
> Interrupt and reg added by: Joel Fernandes <joelf@ti.com>
> Compatible added by Balaji TK <balajitk@ti.com>
> ti,needs-special-hs-handling added by Gururaja Hebbar <gururaja.hebbar@ti.com>
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   26 +++++++++++++-
>  arch/arm/boot/dts/am335x-bone.dts                  |    7 ++++
>  arch/arm/boot/dts/am335x-evm.dts                   |    7 ++++
>  arch/arm/boot/dts/am335x-evmsk.dts                 |    7 ++++
>  arch/arm/boot/dts/am33xx.dtsi                      |   38 ++++++++++++++++++++
>  5 files changed, 84 insertions(+), 1 deletion(-)

Excuse my ignorance, but which git repository is this against ?

