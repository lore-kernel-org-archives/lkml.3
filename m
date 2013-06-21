Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161290Ab3FUMXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:23:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59220 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161045Ab3FUMXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:23:39 -0400
Message-ID: <51C4458D.4060202@ti.com>
Date: Fri, 21 Jun 2013 17:52:37 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Sekhar Nori <nsekhar@ti.com>, Joel A Fernandes <joelagnel@ti.com>,
        Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Benoit Cousson <b-cousson@ti.com>,
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
Subject: Re: [PATCH v12 09/11] spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <1371762407-24544-10-git-send-email-joelagnel@ti.com> <51C42A71.1090403@ti.com> <51C42CFF.10002@ti.com> <20130621112832.GS27646@sirena.org.uk>
In-Reply-To: <20130621112832.GS27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On Friday 21 June 2013 04:58 PM, Mark Brown wrote:
> On Fri, Jun 21, 2013 at 04:07:51PM +0530, Sekhar Nori wrote:
>
>> We can resend the patch if you don't have it from the mailing list.
> I'll probably have it assuming it's been sent to some mailing list I
> read (the CC list here looks absurldy large...) but if you don't send me
> the patch and/or ignore bounces then it's going to take longer.
I have send you this patch seperately.

Thanks ,
Sourav
