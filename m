Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaFJTj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:39:28 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:32840 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbaFJTj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:39:27 -0400
Message-ID: <53975EE9.8010202@mm-sol.com>
Date: Tue, 10 Jun 2014 22:39:21 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] mmc: sdhci-msm: Fix fallout from sdhci refactoring
References: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.06.14, 21:27, Stephen Boyd wrote:
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

Reviewed-by: Georgi Djakov <gdjakov@mm-sol.com>

