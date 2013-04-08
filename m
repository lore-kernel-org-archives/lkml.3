Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935271Ab3DHJbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:31:06 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39686 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3DHJbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <1364273016-18270-1-git-send-email-sachin.kamat@linaro.org>
References: <1364273016-18270-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 8 Apr 2013 15:01:03 +0530
Message-ID: <CAK9yfHwn=m-esDYM_CknOLknyqr4-JbpH+ttOkzbFCRUFdOPmw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: max77686: Use NULL instead of 0
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 10:13, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> 'data' is a pointer and hence use NULL instead of 0.
> Silences the following warning:
> drivers/mfd/max77686.c:49:50: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/mfd/max77686.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 4d73963..1cbb176 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -46,7 +46,7 @@ static struct regmap_config max77686_regmap_config = {
>
>  #ifdef CONFIG_OF
>  static struct of_device_id max77686_pmic_dt_match[] = {
> -       {.compatible = "maxim,max77686",        .data = 0},
> +       {.compatible = "maxim,max77686", .data = NULL},
>         {},
>  };
>
> --
> 1.7.4.1
>

Ping Samuel :)

-- 
With warm regards,
Sachin
