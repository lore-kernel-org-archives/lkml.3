Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbaJUPtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:49:50 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:62010 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbaJUPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:49:48 -0400
MIME-Version: 1.0
In-Reply-To: <544637A3.8010002@ti.com>
References: <1411721657-9924-1-git-send-email-gabriel.fernandez@linaro.org>
	<1411721657-9924-3-git-send-email-gabriel.fernandez@linaro.org>
	<544637A3.8010002@ti.com>
Date: Tue, 21 Oct 2014 17:49:46 +0200
Message-ID: <CAG374jCq1b14N_k3_j4WY-yGcXm7ChFQat5mUqgs6ZQ=UP397g@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] phy: miphy28lp: Add MiPHY28lp header file for DT x
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
        Lee Jones <lee.jones@linaro.org>,
        alexandre torgue <alexandre.torgue@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

To be sure, if i rename MIPHY_TYPE_SATA into PHY_TYPE_SATA, i have to
rename the filename also ?

include/dt-bindings/phy/phy-miphy.h into include/dt-bindings/phy/phy.h

am I right?

Best Regards

Gabriel

On 21 October 2014 12:38, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi Gabriel,
>
> On Friday 26 September 2014 02:24 PM, Gabriel FERNANDEZ wrote:
>> This provides the shared header file which will be reference from both
>> the MiPHY28lp driver and its associated Device Tree node(s).
>>
>> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  include/dt-bindings/phy/phy-miphy.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>  create mode 100644 include/dt-bindings/phy/phy-miphy.h
>>
>> diff --git a/include/dt-bindings/phy/phy-miphy.h b/include/dt-bindings/phy/phy-miphy.h
>> new file mode 100644
>> index 0000000..9bc49b9
>> --- /dev/null
>> +++ b/include/dt-bindings/phy/phy-miphy.h
>> @@ -0,0 +1,12 @@
>> +/*
>> + * This header provides constants for the phy framework
>> + * based on the STMicroelectronics miphxxxx.
>> + */
>> +#ifndef _DT_BINDINGS_PHY_MIPHY
>> +#define _DT_BINDINGS_PHY_MIPHY
>> +
>> +#define MIPHY_TYPE_SATA              1
>> +#define MIPHY_TYPE_PCIE              2
>> +#define MIPHY_TYPE_USB               3
>
> Since these PHY types are common across SoCs, we can have something like
> PHY_TYPE_SATA, PHY_TYPE_PCIE so that each SoCs don't have to create a separate
> header file.
>
> Cheers
> Kishon
