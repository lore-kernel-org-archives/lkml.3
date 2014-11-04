Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaKDKDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:03:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60077 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKDKDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:03:31 -0500
Message-ID: <5458A40B.7080603@ti.com>
Date: Tue, 4 Nov 2014 15:31:47 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gabriel Fernandez <gabriel.fernandez@linaro.org>
CC: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>, <gregory.clement@free-electrons.com>,
        <jason@lakedaemon.net>, <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v4 2/8] phy: miphy28lp: Add PHY header file for DT x Driver
 defines
References: <1413962067-25557-1-git-send-email-gabriel.fernandez@linaro.org>	<1413962067-25557-3-git-send-email-gabriel.fernandez@linaro.org>	<54589B78.3040104@ti.com> <CAG374jDfd24odPXMGC1=1ckaeukk=8Pix1j_bspH5prNpJWhQw@mail.gmail.com>
In-Reply-To: <CAG374jDfd24odPXMGC1=1ckaeukk=8Pix1j_bspH5prNpJWhQw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 04 November 2014 03:28 PM, Gabriel Fernandez wrote:
> Hi Kishon,
> 
> Sure, I'll update my patch set and sent to you soon as possible.

cool, thanks.

-Kishon
> 
> Best Regards
> 
> Gabriel
> 
> On 4 November 2014 10:25, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi Gabriel,
>>
>> On Wednesday 22 October 2014 12:44 PM, Gabriel FERNANDEZ wrote:
>>> This provides the shared header file which will be reference from both
>>> PHY driver and its associated Device Tree node(s).
>>>
>>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>>> ---
>>>  include/dt-bindings/phy/phy.h | 17 +++++++++++++++++
>>>  1 file changed, 17 insertions(+)
>>>  create mode 100644 include/dt-bindings/phy/phy.h
>>>
>>> diff --git a/include/dt-bindings/phy/phy.h b/include/dt-bindings/phy/phy.h
>>> new file mode 100644
>>> index 0000000..a142c69
>>> --- /dev/null
>>> +++ b/include/dt-bindings/phy/phy.h
>>> @@ -0,0 +1,17 @@
>>> +/*
>>> + *
>>> + * This header provides constants for the phy framework
>>> + *
>>> + * Copyright (C) 2014 STMicroelectronics
>>> + * Author: Gabriel Fernandez <gabriel.fernandez@st.com>
>>> + * License terms:  GNU General Public License (GPL), version 2
>>> + */
>>> +
>>> +#ifndef _DT_BINDINGS_PHY
>>> +#define _DT_BINDINGS_PHY
>>> +
>>> +#define PHY_TYPE_SATA                1
>>> +#define PHY_TYPE_PCIE                2
>>> +#define PHY_TYPE_USB         3
>>
>> Can we have a separate #define for USB2 and USB3? Looks like Gregory will need
>> it for Armada 375 SoC.
>>
>> Thanks
>> Kishon
