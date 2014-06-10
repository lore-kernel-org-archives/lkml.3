Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaFJS7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:59:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34416 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaFJS7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:59:31 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH] mmc: sdhci-msm: Fix fallout from sdhci refactoring
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org>
Date: Tue, 10 Jun 2014 13:59:25 -0500
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@linaro.org>, Georgi Djakov <gdjakov@mm-sol.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BB4C39AE-74FB-4F10-B08C-CA036C11F1D5@codeaurora.org>
References: <1402424839-25514-1-git-send-email-sboyd@codeaurora.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 10, 2014, at 1:27 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

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
> ---
> 
> Patch based on next-20140610
> 
> drivers/mmc/host/sdhci-msm.c | 4 ++++
> 1 file changed, 4 insertions(+)

Acked-by: Kumar Gala <galak@codeaurora.org>

Feel free to pick up this version of the patch and ignore mine.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

