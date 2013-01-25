Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3AYHCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:02:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50395 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3AYHCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:02:12 -0500
Message-ID: <51022E04.6040204@ti.com>
Date: Fri, 25 Jan 2013 12:32:28 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 00/14] DMA Engine support for AM33XX
References: <1358281974-8411-1-git-send-email-mporter@ti.com> <50FFC48B.80902@ti.com> <20130123204917.GA5256@beef> <8ea1d227d84648f68e670c56f27c481e@DFLE72.ent.ti.com> <20130124204943.GE5256@beef>
In-Reply-To: <20130124204943.GE5256@beef>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013 02:19 AM, Matt Porter wrote:
> On Thu, Jan 24, 2013 at 05:12:05AM +0000, Shilimkar, Santosh wrote:
>> On Thursday 24 January 2013 02:19 AM, Matt Porter wrote:
>>> On Wed, Jan 23, 2013 at 04:37:55PM +0530, Santosh Shilimkar wrote:
>>>> Matt,
>>>>
>>>> On Wednesday 16 January 2013 02:02 AM, Matt Porter wrote:
>>>>

[...]
>
>>> Thanks for the catch, I'll add this in with your tested line as well for
>>> the series.
>
> BTW, since I'm dropping mmc support from this series, I'll move your
> patch into a separate series with only the mmc pieces.
>
Fine by me
