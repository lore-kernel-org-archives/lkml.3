Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbaJ1Gr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:47:27 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39030 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471AbaJ1GrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:47:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAAVeFuL2MvbC9U-8fM=QPhkvnaMRZ8kep9WpD8hhU4m4cGWjLw@mail.gmail.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
	<1414427215-14380-7-git-send-email-romain.perier@gmail.com>
	<20141027164214.GF14253@saruman>
	<CAAVeFuL2MvbC9U-8fM=QPhkvnaMRZ8kep9WpD8hhU4m4cGWjLw@mail.gmail.com>
Date: Tue, 28 Oct 2014 07:47:21 +0100
Message-ID: <CABgxDo+k8sRBjHdh_6dkizuXR0oxydvjBh3JHsi-x5sP96BMfA@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] ARM: dts: tegra: Use standard power-off property
 in tps65911 for tegra30 apalis
From: Romain Perier <romain.perier@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Johan Hovold <johan@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old property is supported. See "[PATCH v1 1/10]" ^^
(of_is_system_power_controller supports both properties...)

2014-10-28 5:34 GMT+01:00 Alexandre Courbot <gnurou@gmail.com>:
> On Tue, Oct 28, 2014 at 1:42 AM, Felipe Balbi <balbi@ti.com> wrote:
>> On Mon, Oct 27, 2014 at 04:26:52PM +0000, Romain Perier wrote:
>>> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>>> ---
>>>  arch/arm/boot/dts/tegra30-apalis.dtsi | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi
>>> index a5446cb..ced4436 100644
>>> --- a/arch/arm/boot/dts/tegra30-apalis.dtsi
>>> +++ b/arch/arm/boot/dts/tegra30-apalis.dtsi
>>> @@ -412,7 +412,7 @@
>>>                       #interrupt-cells = <2>;
>>>                       interrupt-controller;
>>>
>>> -                     ti,system-power-controller;
>>> +                     system-power-controller;
>>
>> this board is broken until this patch is applied.
>
> It should not. Supporting a new property in the tps65911 is fine, but
> the old property must keep being supported to preserve DT
> compatibility. If a change removing support for
> "ti,system-power-controller" has landed in -next, then it should be
> removed.
