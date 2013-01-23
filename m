Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3AWIz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:55:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37893 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3AWIz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:55:56 -0500
Message-ID: <50FFA593.7040006@ti.com>
Date: Wed, 23 Jan 2013 09:55:47 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Luciano Coelho <coelho@ti.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport power
 functions
References: <20130117093417.GH10814@arwen.pp.htv.fi> <50F7CA82.4050509@ti.com> <20130117100510.GI10814@arwen.pp.htv.fi> <20130117100919.GJ10814@arwen.pp.htv.fi> <1358418917.6252.31.camel@cumari.coelho.fi> <50F7D535.6030205@ti.com> <20130117173131.GL14149@atomide.com> <1358445456.6252.64.camel@cumari.coelho.fi> <20130117231608.GP14149@atomide.com> <50F91FE2.3020402@ti.com> <20130118174910.GF15361@atomide.com>
In-Reply-To: <20130118174910.GF15361@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 01/18/2013 06:49 PM, Tony Lindgren wrote:
> Currently it seems that we need the following working with DT to have panda
> and blaze usable:
> 
> 1. MMC (done)
> 2. USB (patches pending for EHCI and MUSB)
> 3. Ethernet (done for blaze, needs USB for panda)
> 4. DSS (various drivers pending, probably still needs some platform init code)
> 5. WLAN (no binding, needs platform init until done)
> 6. Audio (done?)

Yes, audio is ready. We are covering OMAP2/3/4/5 (adding OMAP1 should not be a
big issue either) with SoC IPs in DT support. We have dmaengine for all OMAP
audio stuff. Codec drivers I maintain in upstream are also works with DT. We
have ASoC machine drivers to cover most of the upstream boards (OMAP3/4/5). So
audio is pretty much done in DT context, we are waiting for the DMA bindings
only AFAIK.

-- 
Péter
