Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaDZPb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:31:26 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63040 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaDZPbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:31:19 -0400
MIME-Version: 1.0
In-Reply-To: <535B9B7E.4090802@gmail.com>
References: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>
	<1397459860-21869-4-git-send-email-t.dakhran@samsung.com>
	<535B9B7E.4090802@gmail.com>
Date: Sat, 26 Apr 2014 19:31:17 +0400
Message-ID: <CANhyOUdPwFL1fjCtrSkzfkG0uWi4Ke7tTg1__cXhjLc8Dvu3jQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] ARM: dts: Add initial device tree support for EXYNOS5410
From: Tarek Dakhran <t.dakhran@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Will be done in next version.

Best regards,
    Tarek

On Sat, Apr 26, 2014 at 3:41 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi,
>
> Since I've started enforcing reference-based DT syntax due to multiple
> advantages over the plain full-tree based one, you should do the same for
> your dts/i files. You can take the series adding support for Exynos5260 as
> an example:
>
> http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29360
>
> Best regards,
> Tomasz
>
> On 14.04.2014 09:17, Tarek Dakhran wrote:
>>
>> Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.
>>
>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>> ---
>>   arch/arm/boot/dts/Makefile                |    1 +
>>   arch/arm/boot/dts/exynos5410-smdk5410.dts |   65 ++++++++++++++
>>   arch/arm/boot/dts/exynos5410.dtsi         |  140
>> +++++++++++++++++++++++++++++
>>   3 files changed, 206 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>>   create mode 100644 arch/arm/boot/dts/exynos5410.dtsi
>>
>
