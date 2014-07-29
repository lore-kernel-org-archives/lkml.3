Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaG2QQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:16:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42352 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaG2QQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <1405704009-8430-3-git-send-email-afaerber@suse.de>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-3-git-send-email-afaerber@suse.de>
Date: Tue, 29 Jul 2014 09:16:11 -0700
X-Google-Sender-Auth: OsDxIIAjdOrOzwtb9_Wy5kezIjc
Message-ID: <CAD=FV=VAWG=H9=mwKZfip9zvAROU3aVXihnaBUBr0GNSzDoWFw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ARM: dts: exynos5250: cypress,cyapa trackpad is
 Snow only
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Fri, Jul 18, 2014 at 10:20 AM, Andreas Färber <afaerber@suse.de> wrote:
> Move it from exynos5250-cros-common.dtsi to exynos5250-snow.dts.
> Spring does not need it, it uses an Atmel maXTouch instead.
>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v2: New (Doug Anderson)
>
>  arch/arm/boot/dts/exynos5250-cros-common.dtsi |  8 --------
>  arch/arm/boot/dts/exynos5250-snow.dts         | 10 ++++++++++
>  2 files changed, 10 insertions(+), 8 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>

Kukjin could apply this now if he wanted to avoid future conflicts.
