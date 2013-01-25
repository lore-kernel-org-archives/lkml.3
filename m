Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3AYLq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:46:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57288 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab3AYLqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:46:18 -0500
Message-ID: <51027071.4060101@ti.com>
Date: Fri, 25 Jan 2013 17:15:53 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 4/4] drivers: usb: start using the control module driver
References: <1359109440-2195-1-git-send-email-kishon@ti.com> <1359109440-2195-5-git-send-email-kishon@ti.com> <20130125102700.GO15886@arwen.pp.htv.fi>
In-Reply-To: <20130125102700.GO15886@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2013 03:57 PM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Jan 25, 2013 at 03:54:00PM +0530, Kishon Vijay Abraham I wrote:
>> Start using the control module driver for powering on the PHY and for
>> writing to the mailbox instead of writing to the control module
>> registers on their own.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   Documentation/devicetree/bindings/usb/omap-usb.txt |    4 ++
>>   Documentation/devicetree/bindings/usb/usb-phy.txt  |    7 +-
>>   arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   13 ----
>
> I'm taking this patch but I'm leaving out the omap_hwmod_44xx_data.c
> change just to kill dependency. Can you send that single change as a
> separate patch which Tony can queue ?
>
Sure.

Thanks
Kishon
