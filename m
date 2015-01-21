Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbbAUNyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:54:20 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33792 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbbAUNyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:54:14 -0500
Message-ID: <54BFAF7E.1030703@collabora.com>
Date: Wed, 21 Jan 2015 14:54:06 +0100
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Chris Ball <chris@printf.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 08/11] mmc: pwrseq_simple: Add support for a delay
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>	<1421338359-27467-9-git-send-email-tomeu.vizoso@collabora.com>	<54B7F9FB.7030100@wwwdotorg.org> <CAPDyKFoO6evBoAbEE30XiZg51KsM-sD4viFMvqaDwGoHeVL-6w@mail.gmail.com>
In-Reply-To: <CAPDyKFoO6evBoAbEE30XiZg51KsM-sD4viFMvqaDwGoHeVL-6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 11:44 AM, Ulf Hansson wrote:
> On 15 January 2015 at 18:33, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>>
>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>
>>
>> Ah, having read the explanation in the next patch, I think ...
>>
>>> diff --git a/Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt
>>> b/Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt
>>
>>
>>> +- delay : delay to wait after driving the reset gpio active [ms].
>>
>>
>> ... delay is the wrong name. reset-pulse-width or reset-pulse-length would
>> be better. delay sounds like a delay after resetting the device before it
>> can be accessed.
> 
> I agree with Stephen's proposal.

Cool.

> This patch needs to be rebased and retested on latest version the
> mmc-pwrseq patches.

Sure.

> Moreover, if you think the patchset which $subject
> patch is a part of is material for 3.20, I will need to share an
> immutable branch with the mmc-pwrseq patches for ARM SOC to pull in,
> tell me if you need that.

I don't think this will make 3.20 as I have other series with higher
priority and there's quite some work left to do on this one.

Regards,

Tomeu

> Kind regards
> Uffe
> 

