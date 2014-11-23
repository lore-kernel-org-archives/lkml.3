Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaKWRTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:19:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaKWRTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:19:04 -0500
Message-ID: <547216FE.3010900@suse.de>
Date: Sun, 23 Nov 2014 18:18:54 +0100
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
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] ARM: dts: add pinctrl support to Exynos5410
References: <1416687984-3546-1-git-send-email-afaerber@suse.de> <1416687984-3546-5-git-send-email-afaerber@suse.de>
In-Reply-To: <1416687984-3546-5-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.11.2014 um 21:26 schrieb Andreas Färber:
> From: Hakjoo Kim <ruppi.kim@hardkernel.com>
> 
> Add the required pin configuration support to Exynos5410 using pinctrl
> interface.
> 
> Signed-off-by: Hakjoo Kim <ruppi.kim@hardkernel.com>
> [AF: Rebased, style changes]
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
> v1 -> v2:
> * Filled in Sob from Hakjoo Kim

Missed one review comment from the RFC, v3 coming up.

Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
