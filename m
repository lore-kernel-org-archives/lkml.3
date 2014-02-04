Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaBDNms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:42:48 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36596 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaBDNmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:42:46 -0500
Date: Tue, 4 Feb 2014 13:42:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: stmpe: Remove unnecessary semicolon
Message-ID: <20140204134240.GH13529@lee--X1>
References: <1391505571-14895-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391505571-14895-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Semicolon is not necessary after the while statement.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/stmpe.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index 42ccd0544513..7145a89364fb 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -706,7 +706,8 @@ static int stmpe1801_reset(struct stmpe *stmpe)
>  		if (!(ret & STMPE1801_MSK_SYS_CTRL_RESET))
>  			return 0;
>  		usleep_range(100, 200);
> -	};
> +	}
> +
>  	return -EIO;
>  }

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
