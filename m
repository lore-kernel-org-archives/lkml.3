Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3GPNj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:39:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38978 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab3GPNj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:39:56 -0400
Message-ID: <51E54D0D.3030200@ti.com>
Date: Tue, 16 Jul 2013 16:39:25 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, <benoit.cousson@linaro.org>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v2 4/4] ARM: OMAP2+: Provide alias to USB PHY clock
References: <1371571487-14389-1-git-send-email-rogerq@ti.com> <1371571487-14389-5-git-send-email-rogerq@ti.com> <51E40199.9070906@ti.com> <20130716123256.GY7656@atomide.com>
In-Reply-To: <20130716123256.GY7656@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 03:32 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130715 07:11]:
>> Hi Tony,
>>
>> On 06/18/2013 07:04 PM, Roger Quadros wrote:
>>> Till the OMAP clocks are correctly defined in device tree, use
>>> this temporary hack to provide clock alias to the USB PHY clocks.
>>>
>>> Without this, USB Host & Ethernet will not be functional with
>>> device tree boots on Panda and uEVM.
>>
>> Looks like this one got missed out.
>>
>> USB host no longer works on Panda with DT boot.
>> Could you please queue this for next 3.11-rc? Thanks.
> 
> OK thanks for checking, applying into omap-for-v3.11/fixes.

Thanks.

> 
> Looks like I also have some pending the .dts changes in
> omap-for-v3.11/dt branch:
> 
> 4cf2198b1e3cee47a1cccbb500b67782c36615d5 ARM: dts: omap3-beagle-xm: Add USB host supprot for Rev. Ax/Bx
> 9bc44515819a00c0ffaf751ad497ddf275089ede ARM: dts: omap3-beagle-xm: Add USB Host support
> fd65d7df4598c1d2ad27d664c719611a1a070edc ARM: dts: omap3-beagle: Make USB host pin naming consistent

Please disregard those. They are old versions.

Benoit had agreed to take the newer version of those for 3.12.

Please pick this one to get usb host working on 3.11 with DT.

http://www.spinics.net/lists/arm-kernel/msg253612.html

> 39ea891d9da6ae1824bc9f689db3f306f5ce0724 ARM: dts: omap4-panda: Add USB Host support

This one is already in through Benoit.

cheers,
-roger
