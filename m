Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3G3Ewp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:52:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52669 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab3G3Ewn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:52:43 -0400
Message-ID: <51F74688.3090702@ti.com>
Date: Tue, 30 Jul 2013 10:22:24 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Balaji TK <balajitk@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v2] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1374515989-7391-1-git-send-email-joelf@ti.com> <51F4589E.5070108@ti.com> <51F6140B.3070600@ti.com> <51F738BF.7070808@ti.com>
In-Reply-To: <51F738BF.7070808@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 July 2013 09:23 AM, Joel Fernandes wrote:
> On 07/29/2013 02:04 AM, Sekhar Nori wrote:
>> On Sunday 28 July 2013 05:02 AM, Joel Fernandes wrote:
>>> Hi Tony or Sekhar,
>>>
>>> If this patch looks ok, could you pick it up for -rc cycle?
>>>
>>> It fixes DMA breakages after the merge window for devices for which DMA
>>> resources are being populated in device tree instead pdev.
>>
>> But which DT-enabled platform in kernel is using EDMA? A grep for edma
>> over arch/arm/boot/dts/* brings up nothing.
>> Does this really have to go into the -rc cycle or can it wait till
>> v3.12?
> 
> 
> But unused channel list is also populated for private EDMA callers like
> davinci-pcm no? IIRC, HWMOD data is also removed for McASP so EDMA for
> those may break.

Yes, but which DT-enabled platform has davinci-pcm working today?
AFAICS, this bug affects DT-enabled platforms only.

Thanks,
Sekhar
