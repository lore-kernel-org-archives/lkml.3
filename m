Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaG2OjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:39:24 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37170 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaG2OjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:39:22 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.62.104]
In-Reply-To: <53D79AD3.8020700@suse.de>
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>
	<1405704009-8430-4-git-send-email-afaerber@suse.de>
	<CABxcv=kP2PCcNCtM1WUXx5wGG4m-jdw-P1dw0boaSwdJpoX=jQ@mail.gmail.com>
	<CAD=FV=V-7+Jj7b8-fQL1PiQhNmhiGOPJzitGd__OUQLDteO_8g@mail.gmail.com>
	<CABxcv=nDsKSdDtVZKpcTP+=3pbeTswJRCUvvXVx98p+1Zzz0Bg@mail.gmail.com>
	<53D79AD3.8020700@suse.de>
Date: Tue, 29 Jul 2014 16:39:19 +0200
Message-ID: <CABxcv=mALxA=dK0Ue_LC1Qz1HUsvf3C4h13q7FgDv+PEoKvRNw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos5250: Fold common ChromeOS parts
 into Snow
From: Javier Martinez Canillas <javier@dowhile0.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: Doug Anderson <dianders@chromium.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
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

Hello Andreas,

On Tue, Jul 29, 2014 at 3:00 PM, Andreas Färber <afaerber@suse.de> wrote:
> Hi Javier and Doug,
>
>
> Hm, in different context it was stated that device trees shouldn't rely
> on bootloader behavior (for a /memory node on Zynq we ended up
> specifying the size cell with the real value despite U-Boot overriding
> it to a lesser value).
>

Well is not strictly the same, the memory node is a hardware
description while the chosen node is one of those exceptional nodes
that don't represent a real device. Also the usage for the memory node
is marked as required in ePAR while the later is marked as optional.

> Can we instead settle on filling this node with defaults? :)
> bootargs = "console=tty1"; would be my choice for Spring. Would that be
> applicable for Snow as well?
> Not sure how to specify that via linux,stdout-path property.
>
> I believe this would be a follow-up patch either way.
>
> Since there's at least two series out there trying to fiddle with
> -cros-common.dtsi, including one that drops the slot sub-node of the MMC
> and one that adds CPU power supply, it would be nice if we can get the
> -cros-common parts sorted out and applied. Can you ack/review 1-2?
> Should I squash them in a v3?
>

A sensible default makes sense to me and yes it should be a follow-up
patch anyways.

> Thanks,
> Andreas
>
> --

Best regards,
Javier
