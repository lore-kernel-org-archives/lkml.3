Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3KRKmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:42:16 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:63668 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3KRKmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:42:05 -0500
Date: Mon, 18 Nov 2013 10:42:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: cros ec: spi: Fix debug output
Message-ID: <20131118104200.GF13640@lee--X1>
References: <1384770649-8593-1-git-send-email-treding@nvidia.com>
 <1384770649-8593-3-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384770649-8593-3-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Thierry Reding wrote:

> The dev_cont() symbol doesn't exist, so replace it with pr_cont(). While
> at it, also append a newline to the debug output to make it look nicer.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/mfd/cros_ec_spi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
