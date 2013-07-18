Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965260Ab3GRVAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:00:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44672 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab3GRVAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:00:11 -0400
Message-ID: <51E8574F.3000905@ti.com>
Date: Thu, 18 Jul 2013 15:59:59 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Trent Piepho <tpiepho@gmail.com>, Sourav Poddar <sourav.poddar@ti.com>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <linux-omap@vger.kernel.org>, <rnayak@ti.com>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com> <1374141687-10790-3-git-send-email-sourav.poddar@ti.com> <CA+7tXij7W_F0ZTQZ=YvK+qOLO+O-6WpTKxLerv8NXyrdydt7FA@mail.gmail.com> <20130718203934.GT22506@sirena.org.uk>
In-Reply-To: <20130718203934.GT22506@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 03:39 PM, Mark Brown wrote:
> On Thu, Jul 18, 2013 at 12:08:30PM -0700, Trent Piepho wrote:
>> On Thu, Jul 18, 2013 at 3:01 AM, Sourav Poddar <sourav.poddar@ti.com> wrote:
>
>>> +- ti,hwmods: Name of the hwmod associated to the QSPI
>
>> What is ti,hwmods?  It's not clear from the description.  It also
>> doesn't appear to be used in the driver.  At least, I did not find any
>> occurrence of "hwmods" in the driver code.
>
> It's a generic thing for all OMAPs which is handled by the core SoC
> support transparently on TI chips.
>
Here are some ancient documentation for the same (pre-device tree) world[1]
bindings documentation is available: 
Documentation/devicetree/bindings/arm/omap/omap.txt


[1] http://omapedia.org/wiki/HWMOD

-- 
Regards,
Nishanth Menon
