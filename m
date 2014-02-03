Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaBCKnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:43:40 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:62164 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBCKni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:43:38 -0500
Date: Mon, 3 Feb 2014 10:43:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: wm5110: Make additional DSP registers available
 to the user
Message-ID: <20140203104331.GT13529@lee--X1>
References: <1390395865-4396-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1390395865-4396-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390395865-4396-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Expose some DSP registers which are useful for DSP users to be able to
> access whilst debugging their firmware.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c           |  168 +++++++++++++++++++++++++++++++++
>  include/linux/mfd/arizona/registers.h |   67 +++++++++++++
>  2 files changed, 235 insertions(+), 0 deletions(-)

These are starting to get a little out of control.

Can you look into using switch's '...' notation please?

Patch applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
