Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbaGWH64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:58:56 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:60821 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbaGWH6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:58:54 -0400
Message-ID: <53CF6B35.30707@st.com>
Date: Wed, 23 Jul 2014 09:58:45 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Kishon Vijay Abraham I <kishon@uda0393678>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infrared.org>,
        <kernel@stlinux.com>
Subject: Re: [STLinux Kernel] [PATCH v3 0/5] phy: miphy365x: Introduce support
 for MiPHY365x
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>	<20140721062805.GA8781@uda0393678> <20140721073959.GR30888@lee--X1> <53CE1154.4010002@ti.com>
In-Reply-To: <53CE1154.4010002@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-23_03:2014-07-22,2014-07-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 07/22/2014 09:23 AM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Monday 21 July 2014 01:09 PM, Lee Jones wrote:
>> Hi Kishon,
>>
>>>> This patchset is based on the two core patches you sent to the
>>>> list which facilitate creating PHYs residing on multi-channel
>>>> controllers.  The changes since the last submission centre
>>>> around dynamic PHY creation based solely on what is provided via
>>>> Device Tree, as requested.  The other review comments have also
>>>> been addressed in this set.
>>>
>>> Merged the first four patches of this series. (merged v3+1 for 1st patch).
>>> I'm not sure who would be merging the dt patch (5/5). But for now I've merged
>>> 2/5 in linux-phy tree since the phy patch seems to be dependent on it.
>>> So the dt patch can be merged only after -rc1. However if whoever merges
>>> dt wants to get it merged during the merge window, I can prepare a common
>>> branch which both of us can merge to. Either ways, dt Maintainer should
>>> let me know.
>>
>> Thanks for applying.  It would be really helpful if you could put just
>> patch 2/5 onto an immutable branch and provide a tag e that Maxime
>> could pull from.
> 
> Sure. Created tag
> git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git
> miphy365x_dt_common_header (branch:miphy365x_dt_header). It is based on 3.16-rc5.

Merged into git://git.stlinux.com/devel/kernel/linux-sti.git sti-dt-for-v3.17-1

Thanks!
Maxime

> 
> Thanks
> Kishon
>>
>> Kind regards,
>> Lee
>>
>>>>   .../devicetree/bindings/phy/phy-miphy365x.txt      |  76 +++
>>>>   arch/arm/boot/dts/stih416-b2020-revE.dts           |  10 +
>>>>   arch/arm/boot/dts/stih416-b2020.dts                |  12 +
>>>>   arch/arm/boot/dts/stih416.dtsi                     |  22 +
>>>>   drivers/phy/Kconfig                                |  10 +
>>>>   drivers/phy/Makefile                               |   1 +
>>>>   drivers/phy/phy-miphy365x.c                        | 636 +++++++++++++++++++++
>>>>   include/dt-bindings/phy/phy-miphy365x.h            |  14 +
>>>>   8 files changed, 781 insertions(+)
>>
> 
> _______________________________________________
> Kernel mailing list
> Kernel@stlinux.com
> http://www.stlinux.com/mailman/listinfo/kernel
> 
