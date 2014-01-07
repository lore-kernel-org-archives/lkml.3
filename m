Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaAGRhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:37:22 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:38944 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaAGRhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:37:16 -0500
Message-ID: <52CC3B48.7080100@koalo.de>
Date: Tue, 07 Jan 2014 18:37:12 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCHv10] dmaengine: Add support for BCM2835
References: <52CB0180.1040605@koalo.de> <20140107161547.GA16227@intel.com>
In-Reply-To: <20140107161547.GA16227@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to you and to all who have looked at/corrected my patch!
I learned a lot!

On 01/07/2014 05:15 PM, Vinod Koul wrote:
> On Mon, Jan 06, 2014 at 08:18:24PM +0100, Florian Meier wrote:
>> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
>> Currently it only supports cyclic DMA.
> Applied, thanks
> 
> --
> ~Vinod
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
