Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbaGOM5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:57:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759132AbaGOM5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:57:18 -0400
Message-ID: <53C5252A.2040301@suse.de>
Date: Tue, 15 Jul 2014 14:57:14 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ARM/SAMSUNG ARM A..." <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: dts: exynos5410: Fill in CPU clock-frequency
References: <1403466596-3347-1-git-send-email-afaerber@suse.de> <53A7DCF8.4090108@samsung.com> <53B690B9.2090906@suse.de> <53B7175B.1030109@samsung.com>
In-Reply-To: <53B7175B.1030109@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

Am 04.07.2014 23:06, schrieb Kukjin Kim:
> BTW Andreas, I can't use 'Färber' in my git tree so which one is right
> or more preferred? Farber, Faerber, Ferber? Sorry.

Hm, git-am should in theory just work fine for this patch with UTF-8 on
Linux. As for Reviewed-by / Tested-by, some people had success with
copy&paste, otherwise Faerber as in the email please.

Thanks,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
