Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaKRLwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:52:35 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:49893 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbaKRLwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:52:33 -0500
Message-ID: <546B32C3.8000602@st.com>
Date: Tue, 18 Nov 2014 12:51:31 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH v5 4/8] ARM: DT: STi: STiH407: Add DT node for MiPHY28lp
References: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org> <1415098284-11182-5-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1415098284-11182-5-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-18_04:2014-11-15,2014-11-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel,
On 11/04/2014 11:51 AM, Gabriel FERNANDEZ wrote:
> The MiPHY28lp is a Generic PHY which can serve various SATA, PCIe or
> USB3 devices. The two first ports can be use for either; both SATA, both
> PCIe or one of each in any configuration.
> The Third port is only for USB3.
>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>   arch/arm/boot/dts/stih407-b2120.dts | 11 +++++++
>   arch/arm/boot/dts/stih407.dtsi      | 65 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 76 insertions(+)

Finally, I won't apply this  patch in its current form.

Indeed, you should follow Arnd recommendations on Syscfg registers 
handling in DT.
See https://lkml.org/lkml/2014/11/13/161

Regards,
Maxime



