Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab3FQNj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:39:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50802 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab3FQNj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:39:26 -0400
Message-ID: <51BF1176.7070608@ti.com>
Date: Mon, 17 Jun 2013 16:39:02 +0300
From: Illia Smyrnov <x0194613@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] spi: omap2-mcspi: Add FIFO buffer support
References: <1371226328-24147-1-git-send-email-illia.smyrnov@ti.com> <1371226328-24147-3-git-send-email-illia.smyrnov@ti.com> <20130617091630.GZ1403@sirena.org.uk>
In-Reply-To: <20130617091630.GZ1403@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.193]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/17/2013 12:16 PM, Mark Brown wrote:
> On Fri, Jun 14, 2013 at 07:12:08PM +0300, Illia Smyrnov wrote:
>> The MCSPI controller has a built-in FIFO buffer to unload the DMA or interrupt
>> handler and improve data throughput. This patch adds FIFO buffer support for SPI
>> transfers in DMA mode.
>
> This looks good but doesn't apply against my topic/omap branch - can you
> please check and resend?  Probably something that applies against -next
> will be fine.
>

I fixed it and sent v4 of "spi: omap2-mcspi: Add FIFO buffer support" patch.
