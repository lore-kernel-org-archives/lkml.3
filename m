Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaLIFi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 00:38:26 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49778 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbaLIFiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 00:38:22 -0500
MIME-Version: 1.0
In-Reply-To: <1417709696-29281-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417709696-29281-1-git-send-email-tomeu.vizoso@collabora.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 9 Dec 2014 14:38:01 +0900
Message-ID: <CAAVeFuJkpuWocEDTfSAK7_UfhZvqOfYJY6sLgsy9i+KcMAkbCQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Add support for Tegra Activity Monitor
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 1:14 AM, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> Hello,
>
> this v3 addresses the comments that the devfreq implementation got, namely:
>
> * Address misc. style issues found by Thierry and Alexander
> * Added helpers for register i/o
> * Further documented the structs
> * Enable the ACTMON after the IRQ handler has been installed
> * Disable the ACTMON before removing the IRQ handler
> * Add governor in a subsys initcall
>
> There's an open question on whether some functionality currently in this
> devfreq driver should be moved into the devfreq framework, but without knowing
> of other SoC family that would benefit from it, I'm reticent. It would be
> great to hear from the devfreq maintainers if they have any plans regarding
> this, or if they have any suggestion.

I cannot make a thorough review because of the problem I mentioned in
patch 3/3, but I am guessing this series is converging towards what we
want. Now the main question will be how we can leverage Arto's
watermark series for this one. I am ready to bet that doing so can
reduce quite a lot of code.

Since you are likely to be the first user of the watermarking feature,
could you comment on its potential shortcomings and whatever needs to
be fixed to best implement ACTMON support using it? I will try to push
it myself, but you are obviously in a better position to understand
what is needed.

Thanks!
