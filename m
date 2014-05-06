Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbaEFIUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:20:31 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:57336 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934235AbaEFIU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140506071843.GD5206@lee--X1>
References: <1399305223-18703-1-git-send-email-gabriel.fernandez@linaro.org>
	<1399305223-18703-2-git-send-email-gabriel.fernandez@linaro.org>
	<20140506071843.GD5206@lee--X1>
Date: Tue, 6 May 2014 10:20:27 +0200
Message-ID: <CAG374jD+msPPbPtFS+ji=8jS9+D-YHu31k7zzzC7Ty7jw9n7jQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] ARM: STi: DT: STiH416: 416 DT Entry for clockgen A0/1/10/11/12
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pankaj Dev <pankaj.dev@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 6 May 2014 09:18, Lee Jones <lee.jones@linaro.org> wrote:
>> Patch adds DT entries for clockgen A0/1/10/11/12
>>
>> Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  arch/arm/boot/dts/stih416-clks.h     |  15 ++
>
> This should live in include/dt-bindings/clk
>
include/dt-bindings/clk or  include/dt-bindings/clock ?

>>  arch/arm/boot/dts/stih416-clock.dtsi | 477 ++++++++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/stih416.dtsi       |  10 +-
>>  3 files changed, 497 insertions(+), 5 deletions(-)
>>  create mode 100644 arch/arm/boot/dts/stih416-clks.h
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

Best regards
