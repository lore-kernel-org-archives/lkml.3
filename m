Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3JCPtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:49:17 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:37783 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3JCPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:49:15 -0400
Date: Thu, 3 Oct 2013 16:49:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mfd: arizona: Correct handling of device tree gpio
 defaults
Message-ID: <20131003154908.GS9048@lee--X1>
References: <1380813361-15400-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380813361-15400-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Oct 2013, Charles Keepax wrote:

> When setting GPIO defaults we are required to make a distinction
> between writing 0x0000 to the registers and leaving them untouched.
> 
> When we receive between 0x0000 and 0xFFFF (inclusive) from either
> Platform Data or Device Tree, we should write the provided
> configuration to the device. Conversely, when we receive >0xFFFF we
> should leave the device configuration at its default setting.
> 
> This patch fixes a bug and ensures that configuration 0x0000 isn't
> mistakenly written when the intention was to keep the default one.
> 
> Reported-by: Heather Lomond <heather.lomond@wolfsonmicro.com>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
> 
> Hi,
> 
> Sorry, your explanation is certainly fine with me.
> 
> Thanks,
> Charles
> 
>  drivers/mfd/arizona-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks Charles.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
