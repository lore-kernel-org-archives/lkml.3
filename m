Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaK1HR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 02:17:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60613 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaK1HRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 02:17:25 -0500
Message-ID: <54782148.6040108@ti.com>
Date: Fri, 28 Nov 2014 09:16:24 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <vinod.koul@intel.com>, <linux-mmc@vger.kernel.org>, <nsekhar@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <khilman@deeprootsystems.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>, <chris@printf.net>,
        <dmaengine@vger.kernel.org>, <ulf.hansson@linaro.org>,
        <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: edma: Rename header file for dmaengine filter
 function definition
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <3300340.ou8f7H2hIc@wuerfel> <54777174.4070203@ti.com> <4859328.eEV7jzKEaA@wuerfel>
In-Reply-To: <4859328.eEV7jzKEaA@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 11:52 PM, Arnd Bergmann wrote:
> On Thursday 27 November 2014 20:46:12 Peter Ujfalusi wrote:
>>
>> I see. With this series I did not planed to fix all edma related issues, just
>> as a start clean up the related header files. I would rather not add fixes to
>> mmc, spi, etc drivers since while you have valid point it is not in the scope
>> of this series.
>> Can we do the changes you are suggesting in an incremental manner?
> 
> Sure, but I'd leave the existing filter function declaration alone then
> and not move it, since we wouldn't want to keep it in the long run.

but if you want to reference the filter function (which is in
drivers/dma/edma.c) in arch/arm/mach-davinci/ directory, we will need it.
Don't we?

If I leave the header as it is, then how would we clean up the edma headers? I
would not put the API definitions for the arch code into the same file as we
have the filter definition.


> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Péter
