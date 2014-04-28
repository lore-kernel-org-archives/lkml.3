Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaD1KY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:24:56 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57748 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaD1KYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:24:51 -0400
Date: Mon, 28 Apr 2014 11:24:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, balbi@ti.com,
        gg@slimlogic.co.uk, kishon@ti.com, ckeepax@opensource.wolfsonmicro.com,
        broonie@kernel.org, k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCHv4 9/9] extcon: palmas: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140428102445.GE21279@lee--X1>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-10-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398386544-16295-10-git-send-email-cw00.choi@samsung.com>
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
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Tested-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/extcon/extcon-palmas.c | 35 ++++++++++++++++++++---------------
>  include/linux/mfd/palmas.h     |  2 +-

For the MFD change(s):
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
