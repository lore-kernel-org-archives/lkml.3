Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaAKTwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:52:30 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:36418 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaAKTw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:52:26 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH RFC 00/10] Generic Device Tree based power domain look-up
Date: Sat, 11 Jan 2014 20:52:17 +0100
Message-ID: <1743034.81eWccWixG@flatron>
User-Agent: KMail/4.12 (Linux/3.12.7-gentoo; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 of January 2014 20:42:42 Tomasz Figa wrote:
> Up till now there was no single generic method to bind devices to their
> power domains using Device Tree. Each platform has been doing this using
> its own way, example of which are Exynos power domain bindings [1] and
> look-up code [2].
> 
> This series is intended to change this and provide generic DT bindings for
> power domain specification and generic code performing look-up of power
> domains and binding them to devices.
> 
> Patches 1, 2, 3 are not directly related to this series, but they are
> dependencies of further patches making mach-s3c64xx a user of introduced
> code. Patch 4 is the most important part of this series, as it's the one
> introducing $subject. Further patches are fixing and adding two users,
> mach-exynos (removing the legacy code) and mach-s3c64xx (no DT support for
> power domains before). Last two patches are adding display support for
> Mini6410 board, including a node for display controller (FIMD) which is
> a power domain consumer.
> 
> Successfully tested on S3C6410-based Mini6410 board.
> 

I left the references for the end of this cover letter and finally forgot
about them. Please accept my apologies ;).

[1] Documentation/devicetree/bindings/arm/exynos/power_domain.txt
[2] arch/arm/mach-exynos/pm_domains.c

Also it might be good to mention that I was heavily inspired by
implementation of clock providers in Common Clock Framework in case of
provider registration and look-up and also by my Exynos power domain
implementation (now removed by this series ;)) in case of code binding
devices to power domains.

Best regards,
Tomasz

