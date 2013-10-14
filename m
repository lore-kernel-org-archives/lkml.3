Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab3JNIpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:45:36 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53834 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3JNIpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:45:35 -0400
Date: Mon, 14 Oct 2013 09:45:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Mark missing AOD registers as volatile
Message-ID: <20131014084530.GB9666@lee--X1>
References: <1381738140-14007-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381738140-14007-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This registers ARIZONA_AOD_WKUP_AND_TRIG and ARIZONA_AOD_IRQ_RAW_STATUS
> contain interrupt status bits and thus should be volatile. They are
> correctly marked on wm5102 but not on wm5110, this patch changes this.
> Furthermore volatile registers don't need defaults so remove those.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c |    1 -
>  drivers/mfd/wm5110-tables.c |    3 ++-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
