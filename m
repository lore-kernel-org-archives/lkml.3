Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbaGAOEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:04:11 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42583 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbaGAOEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:04:09 -0400
Date: Tue, 1 Jul 2014 15:04:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, broonie@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 4/4] mfd: sec-core: Prepare regulators for suspend
 state to reduce power-consumption
Message-ID: <20140701140403.GK27971@lee--X1>
References: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
 <1403680487-12141-5-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403680487-12141-5-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Chanwoo Choi wrote:

> This patch use regulator_suspend_prepare() function to prepare the proper state
> of regulators for suspend state to remove un-necessary leakage power-consumption.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/mfd/Kconfig    |  1 +
>  drivers/mfd/sec-core.c | 10 ++++++++++
>  2 files changed, 11 insertions(+)

Looks reasonable to me:

  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
