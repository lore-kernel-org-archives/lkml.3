Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3FNFgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:36:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54151 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3FNFgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:36:31 -0400
Message-ID: <51BAABB0.5060107@ti.com>
Date: Fri, 14 Jun 2013 11:05:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: <tony@atomide.com>, <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 1/4] arm: omap: Add phy binding info for musb in plat
 data
References: <1368796954-3499-1-git-send-email-kishon@ti.com> <51A43E0A.8090201@ti.com> <51B9C3B6.1080707@ti.com>
In-Reply-To: <51B9C3B6.1080707@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 13 June 2013 06:35 PM, Tomi Valkeinen wrote:
> Hi,
>
> On 28/05/13 08:18, Kishon Vijay Abraham I wrote:
>> Hi Tony,
>>
>> On Friday 17 May 2013 06:52 PM, Kishon Vijay Abraham I wrote:
>>> In order for controllers to get PHY in case of non dt boot, the phy
>>> binding information (phy label) should be added in the platform
>>> data of the controller.
>>
>> This series would be needed to get MUSB working in OMAP3 boards for
>> non-dt boot case. Do you think this is good enough to go in this rc cycle?
>
> Did this or some other solution go forward? I'm still unable to boot
> with usb-gadget-ethernet with v3.10-rc5.

No. I think Tony is ok to take this only during next merge window.

Thanks
Kishon
