Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423694Ab3FVDg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 23:36:59 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:41030 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423471Ab3FVDg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 23:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=GYpbjZJeebxaJ=zNc9R=pkSoVsu_3D9deaOr7enuONNc0wQ@mail.gmail.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
	<51C42A85.8090705@ti.com>
	<CAD=GYpbjZJeebxaJ=zNc9R=pkSoVsu_3D9deaOr7enuONNc0wQ@mail.gmail.com>
Date: Fri, 21 Jun 2013 22:36:56 -0500
Message-ID: <CAD=GYpYpHt8GBeMsHo5nhJy5UCc-R7rbtJX8mJjtoXoti+9Zuw@mail.gmail.com>
Subject: Re: [PATCH v12 00/11] DMA Engine support for AM33XX
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Joel A Fernandes <joelagnel@ti.com>, Tony Lindgren <tony@atomide.com>,
        Matt Porter <matt@ohporter.com>,
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
        Arnd Bergmann <arnd@arndb.de>, broonie@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 7:07 PM, Joel A Fernandes <agnel.joel@gmail.com> wrote:
> Hi Sekhar,
>
> On Fri, Jun 21, 2013 at 5:27 AM, Sekhar Nori <nsekhar@ti.com> wrote:
>> Joel,
>>
>> On 6/21/2013 2:36 AM, Joel A Fernandes wrote:
>>> From: Joel A Fernandes <agnel.joel@gmail.com>
>>>
>>> This series is remaining of Matt Porter's EDMA patches for AM33XX EDMA support
>>> with changes for few pending review comments on v11 series.
>>
>> I have posted a branch with fixes for patches accepted by me in this
>> series (also posted inline as replies to specific patches).
>>
>> https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git/log/?h=v3.11/soc-2
>>
>> Can you please give it a good test - especially on AM335x? I will send a
>> pull request after you confirm. If you find bugs please send incremental
>> patches so I can merge into the original patch.
>
> [Joel]
> This breaks on AM33XX due to dangling pointer, I sent a follow up
> patch addressing it.
>
> However, with this branch I still get..
> mmc: unable to obtain RX DMA engine channel 25

[Joel]
Fixed. I posted a v2 patch. With this, on v3.11/soc-2 branch - AM33xx
MMC is working (root fs mount).

Tested-by: Joel A Fernandes <joelagnel@ti.com>

Thanks,
Joel
