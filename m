Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3DPJ05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:26:57 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:41674 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3DPJ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130416091300.GD25040@arwen.pp.htv.fi>
References: <1366103404-14105-1-git-send-email-ks.giri@samsung.com>
	<20130416091300.GD25040@arwen.pp.htv.fi>
Date: Tue, 16 Apr 2013 14:51:16 +0530
Message-ID: <CAKrE-KcvNYNztSfVaecmbu4kbsD5DFM83va0sm8bsSKceBOiNw@mail.gmail.com>
Subject: Re: [PATCH] ahci: sata: add support for exynos5440 sata
From: Girish KS <girishks2000@gmail.com>
To: balbi@ti.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 2:43 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Apr 16, 2013 at 02:40:04PM +0530, Girish K S wrote:
>> This patch adds the compatible string of the exynos5440 sata controller
>> compliant with the ahci 1.3 and sata 3.0 specification.
>>
>> Signed-off-by: Girish K S <ks.giri@samsung.com>
>> ---
>>  drivers/ata/ahci_platform.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
>> index 7a8a284..c06f021 100644
>> --- a/drivers/ata/ahci_platform.c
>> +++ b/drivers/ata/ahci_platform.c
>> @@ -327,6 +327,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
>>
>>  static const struct of_device_id ahci_of_match[] = {
>>       { .compatible = "snps,spear-ahci", },
>> +     { .compatible = "samsung,exynos5440-ahci", },
>
> is this an IP designed by samsung or something you licensed from e.g
> snps ? If the latter you should add:
>
> "snps,ahci"
>
> instead. Right ?
Yes right. Its a licensed IP. Thanks a lot
>
> --
> balbi
