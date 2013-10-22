Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3JVJH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:07:28 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:43610 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3JVJH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 05:07:27 -0400
Date: Tue, 22 Oct 2013 10:07:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Chen <peter.chen@freescale.com>
Cc: sameo@linux.intel.com, b29396@freescale.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] mfd: syscon: return -ENOSYS if CONFIG_MFD_SYSCON
 is not enabled
Message-ID: <20131022090723.GF19112@lee--X1>
References: <1382431585-26649-1-git-send-email-peter.chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382431585-26649-1-git-send-email-peter.chen@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013, Peter Chen wrote:

> Some platforms may not define CONFIG_MFD_SYSCON (or haven't syscon),
> it can fix build error for these platforms.
> 
> Signed-off-by: Peter Chen <peter.chen@freescale.com>
> 
> ---
> 
> Changes for v2:
> - Using #ifdef instead of IS_ENABLED
> - Using ENOSYS instead of ENXIO as return val
> 
>  include/linux/mfd/syscon.h |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
