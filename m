Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161037AbaDBXFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:05:33 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39593 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472AbaDBXF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:05:28 -0400
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
Subject: Re: [PATCH v7 0/3] Exynos 5410 support
References: <1393213435-20863-1-git-send-email-t.dakhran@samsung.com>
Date: Wed, 02 Apr 2014 16:05:25 -0700
In-Reply-To: <1393213435-20863-1-git-send-email-t.dakhran@samsung.com> (Tarek
	Dakhran's message of "Mon, 24 Feb 2014 12:43:52 +0900")
Message-ID: <7h7g772uyy.fsf@paris.lan>
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
> Has been build on Linux Kernel v3.14-rc1 (Samsung kernel,
> 	for-next branch,
> 	commit aaeeda6f57833c7c0e16fef3d76205f36882c21b,
> 	"Merge branch 'v3.15-next/cleanup-samsung' into for-next")
> Has been tested on Exynos 5410 reference board (exynos_defconfig)
>
> I hope, this is enough clean and hasn't any dependencies to go through 
> Samsung tree.

FWIW: boot tested on Exynos 5410 odroid-xu.

Tested-by: Kevin Hilman <khilman@linaro.org>

What's the status of this being queued up for upstream?  Looks like it
just needs to be broken up in to a drivers/clk pull request and a
arm-soc pull request.

Kevin
