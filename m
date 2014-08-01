Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaHAQpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:45:41 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:38247 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaHAQpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <1406868897-26874-3-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
	<1406868897-26874-3-git-send-email-afaerber@suse.de>
Date: Fri, 1 Aug 2014 09:45:31 -0700
X-Google-Sender-Auth: LklrXMe4ft6NonQAZ_DjoQ_zhEU
Message-ID: <CAD=FV=USKuOxiFo=VgEB6aAQ=LdLv-7+jXQNh4VCMBQwasygxg@mail.gmail.com>
Subject: Re: [PATCH v5 02/10] ARM: dts: Fold exynos5250-cros-common into exynos5250-snow
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
> exynos5250-cros-common.dtsi was meant for sharing common pieces across
> ChromeOS devices. This turned out premature, as several devices ended up
> in the common file that are not common after all. Since the remaining
> common ChromeOS pieces are fairly minor,  exynos5250-cros-common.dtsi
> was requested to be merged into the Snow device tree, sharing only the
> keyboard controller for now. This may be re-evaluated as both mature.
>
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v4 -> v5:
>  * Extended commit message (Tomasz Figa)
>
>  v3 -> v4: Unchanged
>
>  v2 -> v3:
>  * Renamed subject to match Kukjin's style
>  * Rebased onto MMC pinctrl bug fix (Doug Anderson)
>
>  v2: New (Doug Anderson)
>
>  arch/arm/boot/dts/exynos5250-cros-common.dtsi | 164 --------------------------
>  arch/arm/boot/dts/exynos5250-snow.dts         | 164 +++++++++++++++++++++++---
>  2 files changed, 145 insertions(+), 183 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>

I'd suggest that this land sooner rather than later to avoid future conflicts.
