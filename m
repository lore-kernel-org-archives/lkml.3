Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbbAPIvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:51:10 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:58332 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbbAPIvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:51:09 -0500
MIME-Version: 1.0
In-Reply-To: <54B7F757.5060002@wwwdotorg.org>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-4-git-send-email-tomeu.vizoso@collabora.com> <54B7F757.5060002@wwwdotorg.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Fri, 16 Jan 2015 09:50:47 +0100
X-Google-Sender-Auth: CKgzC5s1XqaJ8zI3S12MkAKFzyQ
Message-ID: <CAAObsKCad9O_=TUQrF7fVbBvjDTmfJsLPgr+EasCyhvY+xhdHg@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] ARM: tegra: Set the sound card model that
 alsaucm expects
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2015 at 18:22, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>
>> Patches are on its way to add a config file to alsaucm for the Nyan
>> boards. Use the same card ID that alsaucm will expect.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>>   arch/arm/boot/dts/tegra124-nyan-big.dts | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts
>> b/arch/arm/boot/dts/tegra124-nyan-big.dts
>> index 43e58a4..9a9cffe 100644
>> --- a/arch/arm/boot/dts/tegra124-nyan-big.dts
>> +++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
>> @@ -1976,9 +1976,9 @@
>>         };
>>
>>         sound {
>> -               compatible = "nvidia,tegra-audio-max98090-nyan-big",
>> +               compatible = "nvidia,tegra-audio-max98090-nyan",
>>                              "nvidia,tegra-audio-max98090";
>
>
> If all the boards that are derived from Nyan truly have identical audio HW
> (or at least any differences can be described by this binding), then it
> seems fine to add "nvidia,tegra-audio-max98090-nyan" to the compatible
> value.



> However, I don't see a reason to remove the board-specific compatible value
> "nvidia,tegra-audio-max98090-nyan-big"; we should always include all the
> values that are relevant.

Ok.

>> -               nvidia,model = "Acer Chromebook 13";
>> +               nvidia,model = "GoogleNyan";
>
>
> Why not just name the UCM config file after the ASoC card name that's
> already in use? Perhaps it's not likely to be unique enough though:-(

Yeah, that would be A13, which isn't terribly useful.

Regards,

Tomeu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
