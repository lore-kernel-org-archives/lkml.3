Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaAGI6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:58:37 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49594 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAGI6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:58:35 -0500
Date: Tue, 7 Jan 2014 08:58:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linus.walleij@linaro.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, swarren@wwwdotorg.org,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH] pinctrl: as3722: Set pin to output mode for some function
Message-ID: <20140107085831.GE3182@lee--X1>
References: <1389084056-17076-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389084056-17076-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jan 2014, Laxman Dewangan wrote:

> From: Mallikarjun Kasoju <mkasoju@nvidia.com>
> 
> If pins are used for function output like pwm, clk32k,
> power good etc then set it as output mode default.
> 
> Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/pinctrl/pinctrl-as3722.c |   20 ++++++++++++++++++++
>  include/linux/mfd/as3722.h       |    1 +
>  2 files changed, 21 insertions(+)

For the MFD change:
  Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
