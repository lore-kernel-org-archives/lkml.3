Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaDYW5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:57:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36770 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaDYW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:56:58 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v8 0/3] Exynos 5410 support
References: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>
Date: Fri, 25 Apr 2014 15:56:55 -0700
In-Reply-To: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com> (Tarek
	Dakhran's message of "Mon, 14 Apr 2014 11:17:37 +0400")
Message-ID: <7hppk5f26g.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarek Dakhran <t.dakhran@samsung.com> writes:

> The series of patches represent support of Exynos 5410 SoC
>
> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
>
> Patches add new platform description, support of clock controller and device
> tree for Exynos 5410.
>
> Has been build on Linux Kernel v3.15-rc1
> Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
> 		    2) Odroid-XU board (exynos_defconfig)

Tested-by: Kevin Hilman <khilman@linaro.org>

I also boot tested (to initramfs) on my odroid-XU and see the 4 "big"
cores booted.  Presumably I'm still missing the u-boot/firmware magic
for the little cores.

Kevin
