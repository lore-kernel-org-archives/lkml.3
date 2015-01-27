Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbbA0M54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:57:56 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:58421 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbbA0M5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:57:54 -0500
MIME-Version: 1.0
In-Reply-To: <54B7F8D2.4040400@wwwdotorg.org>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-7-git-send-email-tomeu.vizoso@collabora.com> <54B7F8D2.4040400@wwwdotorg.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 27 Jan 2015 13:57:33 +0100
X-Google-Sender-Auth: eQ-ZwTdunrwwPPOHjko9k7dfqqc
Message-ID: <CAAObsKBfBREzQueA8NRJ0msi7g=5s9Sd2riSEF+0jp8JSbT-mw@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] ARM: tegra: Move out nyan-generic parts out from
 the nyan-big DT
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

On 15 January 2015 at 18:28, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>
>> In preparation for adding the DT for the nyan-blaze board.
>
>
> "git format-patch -C" might help here; hopefully it'd highlight that
> arch/arm/boot/dts/tegra124-nyan.dtsi was a copy from
> arch/arm/boot/dts/tegra124-nyan-big.dts, with just a few small diffs?

It doesn't, because we keep the pinmux config in the leaf files.

Regards,

Tomeu
