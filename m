Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbbAUKon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:44:43 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:33841 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbbAUKog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <54B7F9FB.7030100@wwwdotorg.org>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
	<1421338359-27467-9-git-send-email-tomeu.vizoso@collabora.com>
	<54B7F9FB.7030100@wwwdotorg.org>
Date: Wed, 21 Jan 2015 11:44:35 +0100
Message-ID: <CAPDyKFoO6evBoAbEE30XiZg51KsM-sD4viFMvqaDwGoHeVL-6w@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] mmc: pwrseq_simple: Add support for a delay
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Chris Ball <chris@printf.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2015 at 18:33, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>
>
> Ah, having read the explanation in the next patch, I think ...
>
>> diff --git a/Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt
>> b/Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt
>
>
>> +- delay : delay to wait after driving the reset gpio active [ms].
>
>
> ... delay is the wrong name. reset-pulse-width or reset-pulse-length would
> be better. delay sounds like a delay after resetting the device before it
> can be accessed.

I agree with Stephen's proposal.

This patch needs to be rebased and retested on latest version the
mmc-pwrseq patches. Moreover, if you think the patchset which $subject
patch is a part of is material for 3.20, I will need to share an
immutable branch with the mmc-pwrseq patches for ARM SOC to pull in,
tell me if you need that.

Kind regards
Uffe
