Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3HLTjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:39:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58897 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HLTjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:39:32 -0400
Message-ID: <52092726.7030505@ti.com>
Date: Mon, 12 Aug 2013 13:19:18 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Sekhar Nori <nsekhar@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sricharan R <r.sricharan@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Chris Ball <cjb@laptop.org>, Arnd Bergmann <arnd@arndb.de>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Balaji TK <balajitk@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <djbw@fb.com>, Olof Johansson <olof@lixom.net>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Matt Porter <matt@ohporter.com>
Subject: Re: [PATCH v3 08/12] dma: edma: Add one more required slot to MAX
 slots
References: <1375719297-12871-1-git-send-email-joelf@ti.com> <1375719297-12871-9-git-send-email-joelf@ti.com> <52087921.8040101@ti.com> <20130812133111.GZ6427@sirena.org.uk>
In-Reply-To: <20130812133111.GZ6427@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 08:31 AM, Mark Brown wrote:
> On Mon, Aug 12, 2013 at 11:26:49AM +0530, Sekhar Nori wrote:
> 
>> No need for a separate patch for this, just do this in the patch where
>> you include the two linked sets.
> 
> Can you guys please think about the CC lists you're using for these
> patch serieses?  I've certainly no interest in random patches to the
> DaVinci DMA controllers, and I suspect the same is true for most of the
> people on the CC list.
> 

Sorry. I was actually getting a sense of this. What I did initially was
I copied the CC list from last years work on the same series hoping that
it would be a complete mail chain. Bad judgement on my part.
I should have paid more attention to Mark's rants about his inbox
getting spammed with this series in those old threads ;)

I guess moving forward I will use get_maintainer.pl and refine my
git-send scripts with only interested folks. Any words of advice on when
to and when not to CC someone remotely connected to a series is welcome.

@Sekhar, let's keep only linux-omap, linux-davinci and few other
interested folks on the CC chain for the rest of review on the series.

Thanks,

-Joel
