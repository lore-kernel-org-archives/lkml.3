Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbaDWNif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:38:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63028 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaDWNi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:38:28 -0400
Date: Wed, 23 Apr 2014 14:38:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, balbi@ti.com,
        gg@slimlogic.co.uk, kishon@ti.com, ckeepax@opensource.wolfsonmicro.com,
        broonie@kernel.org, k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCHv2 6/9] extcon: palmas: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140423133821.GL640@lee--X1>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
 <1398081742-24277-7-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398081742-24277-7-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
> 
> Cc: Graeme Gregory <gg@slimlogic.co.uk>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/extcon-palmas.c | 35 ++++++++++++++++++++---------------
>  include/linux/mfd/palmas.h     |  2 +-
>  2 files changed, 21 insertions(+), 16 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
