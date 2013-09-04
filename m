Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909Ab3IDPPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:15:02 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:59924 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3IDPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:15:00 -0400
MIME-Version: 1.0
In-Reply-To: <201309041632.13150.marex@denx.de>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
	<1378276263-10735-5-git-send-email-sachin.kamat@linaro.org>
	<201309041632.13150.marex@denx.de>
Date: Wed, 4 Sep 2013 20:44:59 +0530
Message-ID: <CAK9yfHwFhC4dCVSRCRDKmvujjsGSatLb+vRi56xYZN=N64Ow_Q@mail.gmail.com>
Subject: Re: [PATCH 5/7] regulator: palmas: Use devm_regulator_register
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Marek Vasut <marex@denx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        nm@ti.com, Laxman Dewangan <ldewangan@nvidia.com>, gg@slimlogic.co.uk,
        yong.shen@linaro.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Nancy.Chen@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2013 20:02, Marek Vasut <marex@denx.de> wrote:
> Dear Sachin Kamat,
>
>> devm_* simplifies the code.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/regulator/palmas-regulator.c |   38
>> @@ -1021,7 +1021,7 @@ static int palmas_regulators_probe(struct
>> platform_device *pdev) id, reg_init);
>>                               if (ret) {
>>                                       regulator_unregister(pmic->rdev[id]);
>> -                                     goto err_unregister_regulator;
>> +                                     return ret;
>>                               }
>
> what about this regulator_unregister() above here?

It should have gone too. I will send a fix for that. Thanks for noticing.



-- 
With warm regards,
Sachin
