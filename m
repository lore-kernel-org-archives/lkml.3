Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaKSGKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 01:10:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41542 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbaKSGKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 01:10:05 -0500
Message-ID: <546C340E.8000209@ti.com>
Date: Wed, 19 Nov 2014 11:39:18 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <p.zabel@pengutronix.de>
CC: <arnd@arndb.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] phy: berlin_usb: depends on RESET_CONTROLLER
References: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com> <1416231192-27056-2-git-send-email-antoine.tenart@free-electrons.com> <546BA05E.4090605@gmail.com>
In-Reply-To: <546BA05E.4090605@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 19 November 2014 01:09 AM, Sebastian Hesselbarth wrote:
> On 17.11.2014 14:33, Antoine Tenart wrote:
>> The Berlin USB PHY driver uses the Berlin reset controller
>> unconditionally. Make it depending on RESET_CONTROLLER.
>>
>> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> 
> Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> 
>> ---
>>   drivers/phy/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index b6da75f563e7..38ca6ff00aef 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -17,7 +17,7 @@ config GENERIC_PHY
>>
>>   config PHY_BERLIN_USB

phy-berlin-usb is not in my phy tree and I don't seem to find anywhere in my
inbox. Care to send them to me?

Thanks
Kishon
