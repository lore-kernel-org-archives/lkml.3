Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaGVHX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:23:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38735 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaGVHXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:23:25 -0400
Message-ID: <53CE1154.4010002@ti.com>
Date: Tue, 22 Jul 2014 12:53:00 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Kishon Vijay Abraham I <kishon@uda0393678>
CC: <linux-arm-kernel@lists.infrared.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>
Subject: Re: [PATCH v3 0/5] phy: miphy365x: Introduce support for MiPHY365x
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org> <20140721062805.GA8781@uda0393678> <20140721073959.GR30888@lee--X1>
In-Reply-To: <20140721073959.GR30888@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 21 July 2014 01:09 PM, Lee Jones wrote:
> Hi Kishon,
> 
>>> This patchset is based on the two core patches you sent to the
>>> list which facilitate creating PHYs residing on multi-channel
>>> controllers.  The changes since the last submission centre
>>> around dynamic PHY creation based solely on what is provided via
>>> Device Tree, as requested.  The other review comments have also
>>> been addressed in this set.
>>
>> Merged the first four patches of this series. (merged v3+1 for 1st patch).
>> I'm not sure who would be merging the dt patch (5/5). But for now I've merged
>> 2/5 in linux-phy tree since the phy patch seems to be dependent on it.
>> So the dt patch can be merged only after -rc1. However if whoever merges
>> dt wants to get it merged during the merge window, I can prepare a common
>> branch which both of us can merge to. Either ways, dt Maintainer should
>> let me know.
> 
> Thanks for applying.  It would be really helpful if you could put just
> patch 2/5 onto an immutable branch and provide a tag e that Maxime
> could pull from.

Sure. Created tag
git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git
miphy365x_dt_common_header (branch:miphy365x_dt_header). It is based on 3.16-rc5.

Thanks
Kishon
> 
> Kind regards,
> Lee
> 
>>>  .../devicetree/bindings/phy/phy-miphy365x.txt      |  76 +++
>>>  arch/arm/boot/dts/stih416-b2020-revE.dts           |  10 +
>>>  arch/arm/boot/dts/stih416-b2020.dts                |  12 +
>>>  arch/arm/boot/dts/stih416.dtsi                     |  22 +
>>>  drivers/phy/Kconfig                                |  10 +
>>>  drivers/phy/Makefile                               |   1 +
>>>  drivers/phy/phy-miphy365x.c                        | 636 +++++++++++++++++++++
>>>  include/dt-bindings/phy/phy-miphy365x.h            |  14 +
>>>  8 files changed, 781 insertions(+)
> 
