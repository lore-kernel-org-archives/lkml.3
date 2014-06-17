Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbaFQOg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:36:59 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:53215 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101AbaFQOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:36:54 -0400
Date: Tue, 17 Jun 2014 15:36:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mfd: arizona: Lower ARIZONA_MAX_CORE_SUPPLIES to 2
Message-ID: <20140617143648.GF29841@lee--X1>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1401699043-16835-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401699043-16835-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014, Charles Keepax wrote:

> There are no Arizona devices with 3 core supplies but we define a fix
> array with space for 3 core supplies. Lower the ARIZONA_MAX_CORE_SUPPLIES
> define to 2, to save a few bytes.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  include/linux/mfd/arizona/core.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
> index 6acb058..2bf1d74 100644
> --- a/include/linux/mfd/arizona/core.h
> +++ b/include/linux/mfd/arizona/core.h
> @@ -18,7 +18,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/mfd/arizona/pdata.h>
>  
> -#define ARIZONA_MAX_CORE_SUPPLIES 3
> +#define ARIZONA_MAX_CORE_SUPPLIES 2
>  
>  enum arizona_type {
>  	WM5102 = 1,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
