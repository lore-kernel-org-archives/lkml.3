Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbbAGT1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:27:20 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:60891 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbbAGT1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:27:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Matt Porter <mporter@linaro.org>,
        Alex Elder <elder@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH v3 0/5] Add common clock support for Broadcom iProc architecture
Date: Wed, 07 Jan 2015 20:26:22 +0100
Message-ID: <3144204.or2m7FRv17@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420658568-22879-1-git-send-email-rjui@broadcom.com>
References: <1420658568-22879-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:jl8hMuN8JEFuJBa8TRY/Jg/5Ci4dvUOfROXaS+1XqjtvQik/fCw
 90ozNia1GogxQFgyxvcno4T/Nhhl1Q9cJ8cwkGyk98UlotOh89PlmMXLf8/v6pqLvb9qIDV
 8FxbkxAt2B2+8yMnVfdQFfSzSuRH5xw+vbQE4Qnlc9q4pPnFjLPLxW6jn8GVIJuLM6QWI5J
 dkq6Jzo5/xlSKiAmzFRbQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2015 11:22:43 Ray Jui wrote:
> This patchset contains the initial common clock support for Broadcom's iProc
> family of SoCs. The iProc clock architecture comprises of various PLLs, e.g.,
> ARMPLL, GENPLL, LCPLL0, MIPIPLL, and etc. An onboard crystal serves as the
> basic reference clock for these PLLs. Each PLL may have several leaf clocks.
> One special group of clocks is the ASIU clocks, which are dervied directly
> from the crystal reference clock.
> 

Looks good to me now.

	Arnd
