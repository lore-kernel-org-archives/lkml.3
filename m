Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaCGIc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:32:57 -0500
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:50137 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaCGIcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:32:54 -0500
Message-ID: <531983D1.7030606@st.com>
Date: Fri, 7 Mar 2014 09:31:13 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/5] Add STiH407 SoC and reference board support
References: <1393589841-6634-1-git-send-email-maxime.coquelin@st.com> <CACRpkdbztgbWn3kmm4gv6OLcX+bPnyK5BCt0SJJcWo+iyGsWvA@mail.gmail.com>
In-Reply-To: <CACRpkdbztgbWn3kmm4gv6OLcX+bPnyK5BCt0SJJcWo+iyGsWvA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

On 03/07/2014 04:11 AM, Linus Walleij wrote:
> On Fri, Feb 28, 2014 at 8:17 PM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:
>
>> This series adds basic support to the STMicroelectronics STiH407 SoC and its
>> B2120 reference board. The STiH407 is a dual-core ARM Cortex-A9 CPU aimed at
>> STB market.
>>
>> Giuseppe Cavallaro (2):
>>    ARM: STi: add pinctrl support for the STiH407 SoC
>>    pinctrl: st: Enhance the controller to manage unavailable registers
>>
>> Maxime Coquelin (3):
>>    ARM: STi: Add STiH407 SoC support
>>    ARM: dts: Add STiH407 SoC support
>>    ARM: dts: STiH407: Add B2120 board support
>
> So I'd like to take the pinctrl patch through my tree and the rest through
> ARM SoC but it seems it does not apply :-/

Sorry, the series was based on v3.14-rc4.

I split the series in two:
	- pinctrl patches based on the linux-pinctrl/devel branch
	- ARM patches on arm_soc

Regards,
Maxime

>
> Yours,
> Linus Walleij
>
