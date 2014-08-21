Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaHUHMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:12:10 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:47138 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaHUHMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <53F4B663.90400@ti.com>
References: <1407944075-8093-1-git-send-email-gabriel.fernandez@linaro.org>
	<1407944075-8093-3-git-send-email-gabriel.fernandez@linaro.org>
	<53F4B663.90400@ti.com>
Date: Thu, 21 Aug 2014 09:12:06 +0200
Message-ID: <CAG374jC5qYWZgsaUZjgp_YU8uYqwxg8SSfzEr8OTVWNvEZXUQQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] phy: miphy28lp: Add MiPHY28lp header file for DT x
 Driver defines
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
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
        alexandre torgue <alexandre.torgue@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

Okay, good.


BR
Gabriel

On 20 August 2014 16:53, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Wednesday 13 August 2014 09:04 PM, Gabriel FERNANDEZ wrote:
>> This provides the shared header file which will be reference from both
>> the MiPHY28lp driver and its associated Device Tree node(s).
>>
>> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  include/dt-bindings/phy/phy-miphy28lp.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>  create mode 100644 include/dt-bindings/phy/phy-miphy28lp.h
>>
>> diff --git a/include/dt-bindings/phy/phy-miphy28lp.h b/include/dt-bindings/phy/phy-miphy28lp.h
>> new file mode 100644
>> index 0000000..7cf9bce
>> --- /dev/null
>> +++ b/include/dt-bindings/phy/phy-miphy28lp.h
>> @@ -0,0 +1,12 @@
>> +/*
>> + * This header provides constants for the phy framework
>> + * based on the STMicroelectronics miph28lp.
>> + */
>> +#ifndef _DT_BINDINGS_PHY_MIPHY28LP
>> +#define _DT_BINDINGS_PHY_MIPHY28LP
>> +
>> +#define MIPHY_TYPE_SATA              1
>> +#define MIPHY_TYPE_PCIE              2
>> +#define MIPHY_TYPE_USB               3
>
> I think we should create a common file for phy so that all user's need not
> create a separate copy of the same thing.
>
> Thanks
> Kishon
