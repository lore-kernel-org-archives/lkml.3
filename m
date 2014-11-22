Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaKVVtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 16:49:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaKVVtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 16:49:17 -0500
Message-ID: <547104D5.4030803@suse.de>
Date: Sat, 22 Nov 2014 22:49:09 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-samsung-soc@vger.kernel.org
CC: Kukjin Kim <kgene@kernel.org>,
        =?UTF-8?B?6rmA7ZWZ7KO8?= <ruppi.kim@hardkernel.com>,
        Humberto Naves <hsnaves@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Johann Pfefferl <johann.pfefferl@siemens.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:PIN CONTROL SUBSY..." <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] pinctrl: exynos: add exynos5410 SoC specific data
References: <1416687984-3546-1-git-send-email-afaerber@suse.de> <1416687984-3546-4-git-send-email-afaerber@suse.de>
In-Reply-To: <1416687984-3546-4-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.11.2014 um 21:26 schrieb Andreas Färber:
> From: Hakjoo Kim <ruppi.kim@hardkernel.com>
> 
> Add Samsung EXYNOS5410 SoC specific data to enable pinctrl
> support for all platforms based on EXYNOS5410.
> 
> Signed-off-by: Hakjoo Kim <ruppi.kim@hardkernel.com>
> [AF: Rebased onto Exynos5260]
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
> v1 -> v2:
> * Filled in Sob from Hakjoo Kim
> * Rebased (.svc, .{g,w}eint_{con,mask,pend} fields dropped)

Ugh, this patch is actually missing exactly this change! Stay tuned...

Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
