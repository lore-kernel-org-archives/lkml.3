Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaKFRAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:00:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38823 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaKFRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:00:12 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] soc: Include drivers/soc/Kconfig only once
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1415201542-29758-1-git-send-email-andreas@gaisler.com>
Date: Thu, 6 Nov 2014 11:00:06 -0600
Cc: Sandeep Nair <sandeep_n@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, software@gaisler.com,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <87C1AE4A-DCB4-4713-A731-AA81E1C920AA@codeaurora.org>
References: <1415201542-29758-1-git-send-email-andreas@gaisler.com>
To: Andreas Larsson <andreas@gaisler.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

On Nov 5, 2014, at 9:32 AM, Andreas Larsson <andreas@gaisler.com> wrote:

> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
> drivers/Kconfig |    2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 1a693d3..622fa26 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -148,8 +148,6 @@ source "drivers/remoteproc/Kconfig"
> 
> source "drivers/rpmsg/Kconfig"
> 
> -source "drivers/soc/Kconfig"
> -
> source "drivers/devfreq/Kconfig"
> 
> source "drivers/extcon/Kconfig"
> -- 
> 1.7.10.4
> 

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

