Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaIRFdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:33:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51364 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaIRFdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:33:19 -0400
Message-ID: <541A6E7E.4040903@ti.com>
Date: Thu, 18 Sep 2014 11:02:46 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <maxime.ripard@free-electrons.com>,
        <linux-samsung-soc@vger.kernel.org>, <patches@linaro.org>,
        <lee.jones@linaro.org>
Subject: Re: [PATCH 7/9] phy: remove .owner field for drivers using module_platform_driver
References: <1408106416-19044-1-git-send-email-peter.griffin@linaro.org> <1408106416-19044-8-git-send-email-peter.griffin@linaro.org> <5419B485.8010002@ti.com> <20140917190401.GA31237@griffinp-ThinkPad-X1-Carbon-2nd>
In-Reply-To: <20140917190401.GA31237@griffinp-ThinkPad-X1-Carbon-2nd>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 18 September 2014 12:34 AM, Peter Griffin wrote:
> Hi Kishon,
> 
> On Wed, 17 Sep 2014, Kishon Vijay Abraham I wrote:
> 
>> Hi,
>>
>> On Friday 15 August 2014 06:10 PM, Peter Griffin wrote:
>>> This patch removes the superflous .owner field for drivers which
>>> use the module_platform_driver or platform_driver_register api,
>>> as this is overriden in __platform_driver_register.
>>>
>>> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> 
> <snip>
>>>  drivers/phy/phy-twl4030-usb.c       | 1 -
>>
>> twl4030-usb doesn't use module_platform_driver. Care to resend this patch
>> along? I've merged all other patches in this series.
> 
> That is true, but it does use platform_driver_register  whih overrides .owner.
> So the patch is stil good I think (fyi see include/linux/platform_device.h).

Indeed. Will merge this one.

Thanks
Kishon
