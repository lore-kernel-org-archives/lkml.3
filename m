Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaG2OMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:12:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54177 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaG2OMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:12:08 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.62.104]
In-Reply-To: <589F7CA3-F245-4299-8E39-36A7FA9F3CBD@goldelico.com>
References: <1406577213-9642-1-git-send-email-marek@goldelico.com>
	<1406577213-9642-4-git-send-email-marek@goldelico.com>
	<CAOf5uwk=ctww=pP4Ae+1C6i-oOtiYTv2NJbj1GpuPwVSKXB4Hw@mail.gmail.com>
	<CAAfyv35jvhzvjCKMwrpa=RQ1JkfcmthCsGDzwLW9Y6bq3Ww_fg@mail.gmail.com>
	<CAOf5uw=Fm9FXEH5ESqDC8pGjMbn5VQ1+MyPJVXSqGh_9+JRLHw@mail.gmail.com>
	<1FA8171E-1B7A-4684-887E-11593BB9C29E@goldelico.com>
	<20140729124120.GS29045@atomide.com>
	<589F7CA3-F245-4299-8E39-36A7FA9F3CBD@goldelico.com>
Date: Tue, 29 Jul 2014 16:12:03 +0200
Message-ID: <CABxcv=n7g8c2ePGKgu_0Y35iearcRoAj9ZH5jDWY9nE+1uUKnA@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm: dts: Add gta04a5 model
From: Javier Martinez Canillas <javier@dowhile0.org>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Marek Belisko <marek.belisko@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 29, 2014 at 3:03 PM, Dr. H. Nikolaus Schaller
<hns@goldelico.com> wrote:
> Hi,
>> So what's the conclusion? Are changes needed to this patch
>> series or not?
>
> I advocate that no changes are needed.
>

I agree with Dr. H. Nikolaus on this regard. A DeviceTree should be a
description of the hardware and if two hardware platforms differs,
then we need two different DTS.

Lately I'm seeing some attempts to abuse u-boot's fdt command, u-boot
should only modify the strictly necessary like the /chosen branch.
Allowing u-boot to mangle the FDT before passing to the kernel just to
avoid some DT duplication doesn't sound like a good idea IMHO.

> BR,
> Nikolaus
>
> --

Best regards,
Javier
