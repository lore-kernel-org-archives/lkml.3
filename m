Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3IQOom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:44:42 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52168 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3IQOol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:44:41 -0400
Date: Tue, 17 Sep 2013 15:44:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: arizona: Update registers for WM5110 DSP
Message-ID: <20130917144433.GZ16984@lee--X1>
References: <1379427784-7193-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379427784-7193-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, Charles Keepax wrote:

> DSPx_CONTROL_1 and DSPx_CLOCKING_1 are not volatile registers and are
> incorrectly marked as such, fix this. Also add the DSP scratch
> registers, which are frequently used to output debug info from the DSP
> core.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
> 
> Version 2 of the patch, improved commit message and turns
> out the scratch registers were missing from the readable
> callback as well.
> 
> Based on Lee Jones's for-mfd-next branch.
> 
> Thanks,
> Charles
> 
>  drivers/mfd/wm5110-tables.c |   34 ++++++++++++++++++++++++++++++++--
>  1 files changed, 32 insertions(+), 2 deletions(-)

If you're sure this is the right configuration, the patch looks good to me.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
