Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaAJKGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:06:47 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39460 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaAJKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:06:45 -0500
Date: Fri, 10 Jan 2014 10:06:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2 1/2] mfd: wm5110: Add registers for headphone short
 circuit control
Message-ID: <20140110100638.GD28141@lee--X1>
References: <1389277765-23914-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389277765-23914-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jan 2014, Charles Keepax wrote:

> Add the registers necessary to enable/disable the headphone short
> circuit protection.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c           |    6 ++++++
>  include/linux/mfd/arizona/registers.h |   27 +++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 0 deletions(-)

I'm assuming the ASoC commit depends on this one?

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
