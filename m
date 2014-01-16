Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaAPANo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:13:44 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:62210 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaAPANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:13:41 -0500
MIME-Version: 1.0
In-Reply-To: <1389754951.14001.4.camel@joe-AO722>
References: <1389754365-31863-1-git-send-email-festevam@gmail.com>
	<1389754951.14001.4.camel@joe-AO722>
Date: Wed, 15 Jan 2014 22:13:40 -0200
Message-ID: <CAOMZO5BirX4pS8BeXM4bydPMREBkLRvOtFtV2aS_-uY8RxdTaw@mail.gmail.com>
Subject: Re: [PATCH] regulator: pfuze100-regulator: Fix some checkpatch complaints
From: Fabio Estevam <festevam@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 1:02 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-01-15 at 00:52 -0200, Fabio Estevam wrote:
>> Fix the following checkpatch error and warning:
>
> While you're at it:
>
>> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> []
>> @@ -309,14 +309,17 @@ static int pfuze_identify(struct pfuze_chip *pfuze_chip)
> []
>> +     case 0x8:
>> +             dev_info(pfuze_chip->dev, "Assuming misprogrammed ID=0x8");
>
> missing "\n" terminating newline and
> missing break (or fallthrough comment)
>
>> +     case 0x0:
>> +             break;
>> +     default:
>> +             dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
>
> invalid vs illegal

Thanks, Joe.

Will address your suggestions through a different patch.

Regards,

Fabio Estevam
