Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3FRKFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:05:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39581 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab3FRKF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:05:29 -0400
Message-ID: <51C030B4.5070707@ti.com>
Date: Tue, 18 Jun 2013 15:34:36 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>, <grant.likely@linaro.org>, <tony@atomide.com>
CC: <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 5/9] ARM: OMAP: USB: Add phy binding information
References: <1371113039-5784-1-git-send-email-kishon@ti.com> <1371113039-5784-6-git-send-email-kishon@ti.com> <20130618094438.GT5461@arwen.pp.htv.fi>
In-Reply-To: <20130618094438.GT5461@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 18 June 2013 03:14 PM, Felipe Balbi wrote:
> On Thu, Jun 13, 2013 at 02:13:55PM +0530, Kishon Vijay Abraham I wrote:
>> In order for controllers to get PHY in case of non dt boot, the phy
>> binding information (phy device name) should be added in the platform
>> data of the controller.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> I would rather not pass strings around, any other way to handle this ?
> Why do you need to pass this string ?

Our old way of binding the controller and the phy using device name 
started creating problems after the devices are created using 
PLATFORM_DEVID_AUTO. Infact non-dt boot is broken in mainline for OMAP3 
platforms for which I have posted a RFC series 
http://www.serverphorums.com/read.php?12,708632 which also uses strings.
I'm not sure of any other way to deal with this.

Thanks
Kishon
