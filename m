Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaHUHMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:12:20 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:41668 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbaHUHMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <53F4B700.1010302@ti.com>
References: <1407944075-8093-1-git-send-email-gabriel.fernandez@linaro.org>
	<1407944075-8093-2-git-send-email-gabriel.fernandez@linaro.org>
	<53F4B700.1010302@ti.com>
Date: Thu, 21 Aug 2014 09:12:14 +0200
Message-ID: <CAG374jBdOJXuyJ__mnxs3Rzq+ERbA0T1e1y5v9Us+OqZq7VOeg@mail.gmail.com>
Subject: Re: [PATCH 1/5] phy: miphy28lp: Add Device Tree bindings for the MiPHY28lp
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
        alexandre torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Kishon, i will fix.


BR

Gabriel.

On 20 August 2014 16:56, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>
>
> On Wednesday 13 August 2014 09:04 PM, Gabriel FERNANDEZ wrote:
>> The MiPHY28lp is a Generic PHY which can serve various SATA or PCIe
>> or USB3 devices.
>>
>> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
>> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  .../devicetree/bindings/phy/phy-miphy28lp.txt      | 126 +++++++++++++++++++++
>>  1 file changed, 126 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
>>
>> diff --git a/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
>> new file mode 100644
>> index 0000000..6e57bd5
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/phy-miphy28lp.txt
>> @@ -0,0 +1,126 @@
>> +STMicroelectronics STi MIPHY28LP PHY binding
>> +============================================
>> +
>> +This binding describes a miphy device that is used to control PHY hardware
>> +for SATA, PCIe or USB3.
>> +
>> +Required properties (controller (parent) node):
>> +- compatible : Should be "st,miphy28lp-phy"
>> +- st,syscfg     : Should be a phandle of the system configuration register group
>
>                 ^^^
> I think here you used space and in the rest of places used tabs.
