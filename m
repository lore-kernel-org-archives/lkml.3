Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3FXLtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:49:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37182 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab3FXLtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:49:39 -0400
Message-ID: <51C8321B.9040605@ti.com>
Date: Mon, 24 Jun 2013 17:18:43 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Joel A Fernandes <joelagnel@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
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
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <20130624101903.GV5523@atomide.com> <51C82FFD.1070100@ti.com>
In-Reply-To: <51C82FFD.1070100@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 June 2013 05:09 PM, Sekhar Nori wrote:
> Sourav,
>
> On 6/24/2013 3:49 PM, Tony Lindgren wrote:
>> Hi,
>>
>> For merging this series, I suggest the following sets:
>>
>> * Joel A Fernandes<joelagnel@ti.com>  [130620 14:13]:
>>>    spi: omap2-mcspi: add generic DMA request support to the DT binding
>>>    spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
>>
>> The spi changes should get merged via the driver list.
> Can you please send just the DT binding patch above to Mark's correct
> address with the relevant lists copied.
>
> Thanks,
> Sekhar
Sure. Will send that.
