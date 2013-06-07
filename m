Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab3FGLQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:16:04 -0400
Received: from void.printf.net ([89.145.121.20]:37655 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3FGLQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:16:01 -0400
From: Chris Ball <cjb@laptop.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Mark Brown <broonie@kernel.org>, Matt Porter <matt@ohporter.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v9 1/9] ARM: davinci: move private EDMA API to arm/common
References: <1362586540-10393-1-git-send-email-mporter@ti.com>
	<1362586540-10393-2-git-send-email-mporter@ti.com>
	<51B17AE7.4070403@ti.com>
Date: Fri, 07 Jun 2013 07:15:39 -0400
In-Reply-To: <51B17AE7.4070403@ti.com> (Sekhar Nori's message of "Fri, 7 Jun
	2013 11:47:11 +0530")
Message-ID: <878v2m5fz8.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 07 2013, Sekhar Nori wrote:
> + Chris since the patch has some davinci_mmc.c changes.
>
> Chris, Mark,
>
> On 3/6/2013 9:45 PM, Matt Porter wrote:
>> Move mach-davinci/dma.c to common/edma.c so it can be used
>> by OMAP (specifically AM33xx) as well.
>> 
>> Signed-off-by: Matt Porter <mporter@ti.com>
>> Acked-by: Sekhar Nori <nsekhar@ti.com>
>
> Can you please ack changes in mmc and sound respectively? I would like
> to take the patch for v3.11.

For davinci_mmc.c:

Acked-by: Chris Ball <cjb@laptop.org>

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
