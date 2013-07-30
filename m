Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab3G3ElY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:41:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53744 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab3G3ElU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:41:20 -0400
Message-ID: <51F738BF.7070808@ti.com>
Date: Mon, 29 Jul 2013 22:53:35 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
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
References: <1374515989-7391-1-git-send-email-joelf@ti.com> <51F4589E.5070108@ti.com> <51F6140B.3070600@ti.com>
In-Reply-To: <51F6140B.3070600@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 02:04 AM, Sekhar Nori wrote:
> On Sunday 28 July 2013 05:02 AM, Joel Fernandes wrote:
>> Hi Tony or Sekhar,
>>
>> If this patch looks ok, could you pick it up for -rc cycle?
>>
>> It fixes DMA breakages after the merge window for devices for which DMA
>> resources are being populated in device tree instead pdev.
> 
> But which DT-enabled platform in kernel is using EDMA? A grep for edma
> over arch/arm/boot/dts/* brings up nothing.
> Does this really have to go into the -rc cycle or can it wait till
> v3.12?


But unused channel list is also populated for private EDMA callers like
davinci-pcm no? IIRC, HWMOD data is also removed for McASP so EDMA for
those may break.

Thanks,

-Joel
