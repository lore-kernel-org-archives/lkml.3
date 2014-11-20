Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbaKTV7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:59:09 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56732 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbaKTV7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:59:07 -0500
Message-ID: <546E6425.9040605@gmail.com>
Date: Thu, 20 Nov 2014 22:59:01 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        p.zabel@pengutronix.de
CC: arnd@arndb.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] phy: berlin_usb: depends on RESET_CONTROLLER
References: <1416231192-27056-1-git-send-email-antoine.tenart@free-electrons.com> <1416231192-27056-2-git-send-email-antoine.tenart@free-electrons.com> <546BA05E.4090605@gmail.com> <546C340E.8000209@ti.com>
In-Reply-To: <546C340E.8000209@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 07:09 AM, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Wednesday 19 November 2014 01:09 AM, Sebastian Hesselbarth wrote:
>> On 17.11.2014 14:33, Antoine Tenart wrote:
>>> The Berlin USB PHY driver uses the Berlin reset controller
>>> unconditionally. Make it depending on RESET_CONTROLLER.
>>>
>>> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
>>
>> Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>
>>> ---
>>>    drivers/phy/Kconfig | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>>> index b6da75f563e7..38ca6ff00aef 100644
>>> --- a/drivers/phy/Kconfig
>>> +++ b/drivers/phy/Kconfig
>>> @@ -17,7 +17,7 @@ config GENERIC_PHY
>>>
>>>    config PHY_BERLIN_USB
>
> phy-berlin-usb is not in my phy tree and I don't seem to find anywhere in my
> inbox. Care to send them to me?

Kishon,

phy-berlin-usb is part of a larger patch set moving chipidea usb to
generic phy. As all other patches of that set have already been taken,
I squashed this into one of the two remaining patches from the said
set. I just sent out the now two remaining patches.

Looks like Antoine simply forgot to put you on Cc, at least for v8
of the patches.

Sebastian

