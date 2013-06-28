Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3F1FRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:17:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44877 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3F1FQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:16:58 -0400
Message-ID: <51CD1C0E.5030000@ti.com>
Date: Fri, 28 Jun 2013 10:45:58 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "'Rob Landley'" <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        "'Benoit Cousson'" <benoit.cousson@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "'Cesar Eduardo Barros'" <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        "'Rajendra Nayak'" <rnayak@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Balaji T K <balajitk@ti.com>,
        "'George Cherian'" <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v9 1/8] drivers: phy: add generic PHY framework
References: <000d01ce73af$62a95a60$27fc0f20$@samsung.com>
In-Reply-To: <000d01ce73af$62a95a60$27fc0f20$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 June 2013 08:57 AM, Jingoo Han wrote:
> On Wed, 26 Jun 2013 17:17:29 +0530, Kishon Vijay Abraham Iwrote:
>> The PHY framework provides a set of APIs for the PHY drivers to
>> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
>> PHY with or without using phandle. For dt-boot, the PHY drivers should
>> also register *PHY provider* with the framework.
>>
>> PHY drivers should create the PHY by passing id and ops like init, exit,
>> power_on and power_off. This framework is also pm runtime enabled.
>>
>> The documentation for the generic PHY framework is added in
>> Documentation/phy.txt and the documentation for dt binding can be found at
>> Documentation/devicetree/bindings/phy/phy-bindings.txt
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> Tested-by: Jingoo Han <jg1.han@samsung.com>
>
> It looks great to me!
>
> I tested this General PHY framework with Exynos5250 eDP.
> It works properly.

Thanks for testing this :-)

> I will share the patch 'Generic PHY driver for the Exynos SoC DP PHY', soon.
> Thanks.

Cool.

Thanks
Kishon
