Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaDPKEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:04:01 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51786 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaDPKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:04:00 -0400
Date: Wed, 16 Apr 2014 11:03:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Keerthy <j-keerthy@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65218: Remove unused *rdev[] from struct tps65218
Message-ID: <20140416100354.GI4754@lee--X1>
References: <1397562009.24265.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397562009.24265.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Axel Lin wrote:

> The *rdev[] is not used since commit 413be59e2f333
> "regulator: tps65218: Remove unnecessary regulator_unregister call".
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  include/linux/mfd/tps65218.h | 1 -
>  1 file changed, 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
