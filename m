Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaFJTmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:42:05 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48054 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaFJTmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:42:03 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] mmc: sdhci-msm: Fix fallout from sdhci refactoring
References: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 10 Jun 2014 12:41:59 -0700
In-Reply-To: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Tue, 10 Jun 2014 11:27:19 -0700")
Message-ID: <7hzjhko8l4.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> The sdhci core was refactored recently and some of those
> refactorings required changes in every sdhci platform driver.
> Those updates happened around the same time as when the msm
> driver was merged so the refactorings missed the msm driver.
> Hook in the basic library functions so that we can boot apq8074
> dragonboards again instead of crashing when we try to jump to
> NULL function pointers.
>
> Reported-by: Kevin Hilman <khilman@linaro.org>
> Cc: Georgi Djakov <gdjakov@mm-sol.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Tested-by: Kevin Hilman <khilman@linaro.org>

I verifed that this patch on top of next-20140610 gets the qcom
dragonboard booting again.

Kevin
