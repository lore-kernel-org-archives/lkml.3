Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3E2FkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:40:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51348 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab3E2FkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:40:02 -0400
Message-ID: <51A59466.6090504@ti.com>
Date: Wed, 29 May 2013 11:08:46 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <akpm@linux-foundation.org>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>
Subject: Re: [PATCH v6 1/9] drivers: phy: add generic PHY framework
References: <1367229812-30574-1-git-send-email-kishon@ti.com> <1367229812-30574-2-git-send-email-kishon@ti.com> <51A531A9.4030800@gmail.com>
In-Reply-To: <51A531A9.4030800@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 29 May 2013 04:07 AM, Sylwester Nawrocki wrote:
> Hi Kishon,
>
> On 04/29/2013 12:03 PM, Kishon Vijay Abraham I wrote:
>> The PHY framework provides a set of APIs for the PHY drivers to
>> create/destroy a PHY and APIs for the PHY users to obtain a reference
>> to the
>> PHY with or without using phandle. For dt-boot, the PHY drivers should
>> also register *PHY provider* with the framework.
>>
>> PHY drivers should create the PHY by passing id and ops like init, exit,
>> power_on and power_off. This framework is also pm runtime enabled.
>>
>> The documentation for the generic PHY framework is added in
>> Documentation/phy.txt and the documentation for dt binding can be
>> found at
>> Documentation/devicetree/bindings/phy/phy-bindings.txt
>>
>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>
> Thanks for working on this. For the record, I plan to give this a try
> in the end of this week, with my simple MIPI CSI/DSI PHY driver. I might
> have some more comments then. For now just couple of remarks after
> reading the documentation.

Thanks for reviewing. I'll wait for your comments before posting the 
next version.

Thanks
Kishon
