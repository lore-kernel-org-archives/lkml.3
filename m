Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaBCKla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:41:30 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:35822 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaBCKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:41:29 -0500
Date: Mon, 3 Feb 2014 10:41:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: wm5102: Make additional DSP registers available
 to the user
Message-ID: <20140203104123.GS13529@lee--X1>
References: <1390395865-4396-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390395865-4396-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Expose some DSP registers which are useful for DSP users to be able to
> access whilst debugging their firmware.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c           |   34 +++++++++++++++++++++++++++++++++
>  include/linux/mfd/arizona/registers.h |   17 ++++++++++++++++
>  2 files changed, 51 insertions(+), 0 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
