Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaD1K0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:26:33 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50561 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbaD1K0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:26:30 -0400
Date: Mon, 28 Apr 2014 11:26:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, carlo@caione.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: core: Don't use devres functions before device is
 added
Message-ID: <20140428102624.GF21279@lee--X1>
References: <1398360445-27107-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398360445-27107-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The supply aliases for the MFD devices were being added using devres but
> the device hasn't been added at this point and as such we can't use
> devres.
> 
> The MFD already has a function that removes devices this patch uses the
> non-devres versions of the supply alias functions and adds an unregister
> in mfd_remove_devices_fn.
> 
> Reported-by: Carlo Caione <carlo@caione.org>
> Reported-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/mfd-core.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
