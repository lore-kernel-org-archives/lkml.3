Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaKLN62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:58:28 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:48233 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaKLN61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:58:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqk1pwGFuitE0Fk1pqyP_FZiQK1=5OtGUM9Zw6Mp_rWXw@mail.gmail.com>
References: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com> <CAPDyKFqk1pwGFuitE0Fk1pqyP_FZiQK1=5OtGUM9Zw6Mp_rWXw@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Wed, 12 Nov 2014 19:27:46 +0530
Message-ID: <CAGOxZ51hfwJEeWYr+-3Ax1Cy9rN68YHzqR-B3pHBxUfkktnk+A@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: add support for ARM64
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Chris Ball <chris@printf.net>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Tue, Sep 9, 2014 at 12:21 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 29 August 2014 12:24, Alim Akhtar <alim.akhtar@samsung.com> wrote:
>> There are upcoming ARM64 SoCs with dw_mmc host controller.
>>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> ---
>>  drivers/mmc/host/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>> index a43295c..72dd6c2 100644
>> --- a/drivers/mmc/host/Kconfig
>> +++ b/drivers/mmc/host/Kconfig
>> @@ -580,7 +580,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
>>  config MMC_DW
>>         tristate "Synopsys DesignWare Memory Card Interface"
>>         depends on HAS_DMA
>> -       depends on ARC || ARM || MIPS || COMPILE_TEST
>> +       depends on ARC || ARM || ARM64 || MIPS || COMPILE_TEST
>
> Before enabling this, wouldn't it be better to add the needed support
> in dw_mmc first? Or there are no changes needed?
>
> There are also ongoing development and discussions for exynos7, which
> I guess relates to this?
> http://www.spinics.net/lists/linux-mmc/msg28294.html
>
The above said patches are merged now in your tree, can you please
consider applying this patch?
Thanks!

> Kind regards
> Uffe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
