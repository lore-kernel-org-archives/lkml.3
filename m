Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaDWMhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:37:05 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:41234 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaDWMg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:36:57 -0400
Date: Wed, 23 Apr 2014 13:36:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: swarren@nvidia.com, wsa@the-dreams.de, abrestic@chromium.org,
        dgreid@chromium.org, olof@lixom.net, sjg@chromium.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        Bill Richardson <wfrichar@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] mfd: cros_ec: Sync to the latest
 cros_ec_commands.h from EC sources
Message-ID: <20140423123650.GF640@lee--X1>
References: <1398185154-19404-1-git-send-email-dianders@chromium.org>
 <1398185154-19404-6-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398185154-19404-6-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> This just updates include/linux/mfd/cros_ec_commands.h to match the
> latest EC version (which is the One True Source for such things).  See
> <https://chromium.googlesource.com/chromiumos/platform/ec>
> 
> [dianders: took today's ToT version from the Chromium OS EC; deleted
> references to cros_ec_dev and cros_ec_lpc since those aren't upstream
> yet]
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>
> Tested-by: Andrew Bresticker <abrestic@chromium.org>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes in v2: None
> 
>  drivers/mfd/cros_ec.c                |    2 +-
>  include/linux/mfd/cros_ec.h          |    4 +-
>  include/linux/mfd/cros_ec_commands.h | 1128 +++++++++++++++++++++++++++++++---
>  3 files changed, 1059 insertions(+), 75 deletions(-)

Waiting for other subsystems to Ack, so for now:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
