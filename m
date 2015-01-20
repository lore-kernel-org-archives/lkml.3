Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbbATOAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:00:25 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:65498 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbbATOAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:00:05 -0500
MIME-Version: 1.0
In-Reply-To: <54B7F7F7.1020202@wwwdotorg.org>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-3-git-send-email-tomeu.vizoso@collabora.com> <54B7F7F7.1020202@wwwdotorg.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 20 Jan 2015 14:59:43 +0100
X-Google-Sender-Auth: CpShWetmRNG64Z94Ua_Yb_si4OA
Message-ID: <CAAObsKAaanrrSYd7gmLAS4K_G9fuU=WmsMXQk0G85hfy_XdE5Q@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] ARM: tegra: Use the generated pinmux data
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

On 15 January 2015 at 18:25, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>
>> Google has submitted a board config for the pinmux programming of the
>> Nyan Big board. Use the whole of it as it's generated to make it easier
>> to update as the configuration gets fixed in the future.
>
>
> Submitted to where? I assume you mean tegra-pinmux-scripts. I don't see a
> Nyan/Nyan-big configuration there yet. IIRC (and I might not) one was
> posted, but there were some review comments that aren't yet addressed?

Yeah, that's what I meant by submitted. TTBOMK the v2 doesn't have any
comments pending of being addressed?

I have just sent a pinmux config file for the blaze that just changes
the configuration of usb_vbus_en0, usb_vbus_en1 and dp_hpd pins.

Regards,

Tomeu
