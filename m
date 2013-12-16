Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3LPNvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:51:24 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46548 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3LPNvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:51:22 -0500
Date: Mon, 16 Dec 2013 13:51:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] mfd: cros ec: spi: Use 0 instead of '\0'
 consistently
Message-ID: <20131216135116.GK18769@lee--X1>
References: <1387192180-15333-1-git-send-email-treding@nvidia.com>
 <1387192180-15333-2-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387192180-15333-2-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013, Thierry Reding wrote:

> memset() was being called with the second parameter set to '\0', which
> is equivalent but longer than the more canonical 0. Update the code to
> use the latter variant consistently across the driver.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v5:
> - new patch
> 
>  drivers/mfd/cros_ec_spi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
