Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3JPO4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:56:41 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:37406 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab3JPO4i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:56:38 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Maxime COQUELIN <maxime.coquelin@st.com>, Wolfram Sang <wsa@the-dreams.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Cc: Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Date: Wed, 16 Oct 2013 16:54:36 +0200
Subject: Re: [PATCH v5 0/4] Add I2C support to ST SoCs
Thread-Topic: [PATCH v5 0/4] Add I2C support to ST SoCs
Thread-Index: Ac7Kf6JDBVE9cYw3S1OTamjP5G1eqQ==
Message-ID: <525EA8AC.4010607@st.com>
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>
In-Reply-To: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On 10/14/2013 02:46 PM, Maxime COQUELIN wrote:
> The goal of this series is to add I2C support to ST SoCs.
> The DT definition is added for STiH415 and STiH416 SoCs on
> B2000 and B2020 boards.
>
> The series has been tested working on STiH416-B2020 board.
> It applies on top of v3.12-rc5.
>
> Changes since v4:
>    - Fixed IRQ flags to level high triggering as reported by Stephen Gallimore
>    - Revert back to generic DT properties for Anti-glitch filtering. Their DT
>      binding documentation will be updated when i2c DT binding docuementation
>      will be created (In Wolfram's ToDo list)
Do you agree with this approach?

Did you had time to review the driver?

Regards,
Maxime

> ...
>
> Maxime Coquelin (4):
>    i2c: busses: i2c-st: Add ST I2C controller
>    ARM: STi: Supply I2C configuration to STiH416 SoC
>    ARM: STi: Supply I2C configuration to STiH415 SoC
>    ARM: STi: Add I2C config to B2000 and B2020 boards
>
>   Documentation/devicetree/bindings/i2c/i2c-st.txt |   38 +
>   arch/arm/boot/dts/stih415-pinctrl.dtsi           |   36 +
>   arch/arm/boot/dts/stih415.dtsi                   |   53 ++
>   arch/arm/boot/dts/stih416-pinctrl.dtsi           |   35 +
>   arch/arm/boot/dts/stih416.dtsi                   |   53 ++
>   arch/arm/boot/dts/stih41x-b2000.dtsi             |    9 +
>   arch/arm/boot/dts/stih41x-b2020.dtsi             |   22 +
>   drivers/i2c/busses/Kconfig                       |   10 +
>   drivers/i2c/busses/Makefile                      |    1 +
>   drivers/i2c/busses/i2c-st.c                      |  867 ++++++++++++++++++++++
>   10 files changed, 1124 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/i2c/i2c-st.txt
>   create mode 100644 drivers/i2c/busses/i2c-st.c
>
