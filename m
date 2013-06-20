Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3FTEvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:51:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40318 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3FTEvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:51:03 -0400
Message-ID: <51C289DC.1080604@ti.com>
Date: Thu, 20 Jun 2013 10:19:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joel A Fernandes <agnel.joel@gmail.com>
CC: Joel A Fernandes <joelagnel@ti.com>, Tony Lindgren <tony@atomide.com>,
        Matt Porter <matt@ohporter.com>,
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
Subject: Re: [PATCH v11 3/8] ARM: edma: Add EDMA crossbar event mux support
References: <1371537499-12970-1-git-send-email-joelagnel@ti.com> <1371537499-12970-4-git-send-email-joelagnel@ti.com> <51C0344F.6010709@ti.com> <CAD=GYpbVUu4H8vkLHYAGPUMqdzmbJncX4yOR+5k+5B8NJhfgAQ@mail.gmail.com>
In-Reply-To: <CAD=GYpbVUu4H8vkLHYAGPUMqdzmbJncX4yOR+5k+5B8NJhfgAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/20/2013 6:06 AM, Joel A Fernandes wrote:

>>> +             /* Clear the xbar mapped channels in unused list */
>>> +             xbar_chans = info[j]->xbar_chans;
>>> +             if (xbar_chans) {
>>> +                     for (i = 0; xbar_chans[i][1] != -1; i++) {
>>> +                             off = xbar_chans[i][1];
>>> +                             clear_bits(off, 1,
>>> +                                     edma_cc[j]->edma_unused);
>>
>> Please fix the alignment here.
> 
> I noticed the alignment was off in a few other places in that driver.
> Fixed those up too.

If you do, please make it a separate (pre)patch.

Thanks,
Sekhar
