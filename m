Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaBDJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:16:56 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:57171 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaBDJQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:16:34 -0500
Date: Tue, 4 Feb 2014 09:16:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend] mfd: stmpe: Remove unnecessary semicolon
Message-ID: <20140204091627.GC13529@lee--X1>
References: <1391504833-20022-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391504833-20022-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Semicolon is not necessary after the while statement.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/stmpe.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index 42ccd0544513..4a91f6771fb8 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -706,7 +706,7 @@ static int stmpe1801_reset(struct stmpe *stmpe)
>  		if (!(ret & STMPE1801_MSK_SYS_CTRL_RESET))
>  			return 0;
>  		usleep_range(100, 200);
> -	};
> +	}
>  	return -EIO;
>  }

Can you re-submit with a new line between it and the return please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
