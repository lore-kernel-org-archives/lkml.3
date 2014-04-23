Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaDWMor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:44:47 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50868 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaDWMfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:35:17 -0400
Date: Wed, 23 Apr 2014 13:35:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: swarren@nvidia.com, wsa@the-dreams.de, abrestic@chromium.org,
        dgreid@chromium.org, olof@lixom.net, sjg@chromium.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] mfd: cros_ec: spi: Make the cros_ec_spi timeout
 more reliable
Message-ID: <20140423123510.GD640@lee--X1>
References: <1398185154-19404-1-git-send-email-dianders@chromium.org>
 <1398185154-19404-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398185154-19404-4-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Doug Anderson wrote:

> The cros_ec_spi transfer had two problems with its timeout code:
> 
> 1. It looked at the timeout even in the case that it found valid data.
> 2. If the cros_ec_spi code got switched out for a while, it's possible
>    it could get a timeout after a single loop.  Let's be paranoid and
>    make sure we do one last transfer after the timeout expires.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>
> Tested-by: Andrew Bresticker <abrestic@chromium.org>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes in v2: None
> 
>  drivers/mfd/cros_ec_spi.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

Waiting for other subsystems to Ack, so for now:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
