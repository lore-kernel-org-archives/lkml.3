Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbaEFMjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:39:42 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35277 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbaEFMjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:39:39 -0400
Message-ID: <5368D806.8050609@linaro.org>
Date: Tue, 06 May 2014 13:39:34 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH 0/4] Enable ST Keyscan driver
References: <1399304320-18197-1-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1399304320-18197-1-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the DT patches look good for me.
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

I think It will be better to send a pull request to Arnd/Olof including 
other reviewed DT patches.

thanks,
srini


On 05/05/14 16:38, Gabriel FERNANDEZ wrote:
> The goal of this series is to enable ST Keyscan support to ST SoCs.
> The DT definition is added for STiH415 and STiH416 SoCs on
> B2000 board.
> Tested on B2000 sti board.
>
> Gabriel Fernandez (4):
>    ARM: STi: DT: add keyscan for stih415
>    ARM: STi: DT: add keyscan for stih416
>    ARM: STi: DT: add keyscan for stih41x-b2000
>    ARM: multi_v7_defconfig: add ST Keyscan driver
>
>   arch/arm/boot/dts/stih415-pinctrl.dtsi | 16 ++++++++++++++++
>   arch/arm/boot/dts/stih415.dtsi         | 12 ++++++++++++
>   arch/arm/boot/dts/stih416-pinctrl.dtsi | 16 ++++++++++++++++
>   arch/arm/boot/dts/stih416.dtsi         | 12 ++++++++++++
>   arch/arm/boot/dts/stih41x-b2000.dtsi   | 23 +++++++++++++++++++++++
>   arch/arm/configs/multi_v7_defconfig    |  1 +
>   6 files changed, 80 insertions(+)
>
