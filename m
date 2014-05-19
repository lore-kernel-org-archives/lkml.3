Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbaESROs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:14:48 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35410 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaESROr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:14:47 -0400
Date: Mon, 19 May 2014 18:14:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] mfd: arizona: Add MICVDD to mapped regulators
Message-ID: <20140519171442.GA20435@lee--X1>
References: <1400517329-1103-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400517329-1103-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently, MICVDD only binds because it is both the regulator name and
> the consumer name and we will always match against the regulator name
> regardless of the consumer device. If the regulator was renamed using
> the init_data ASoC will no longer be able to locate the supply, as it
> will be looking on the CODEC device where as the MICVDD consumer is on
> the Arizona device. Add a mapping as we do for the other regulators.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
