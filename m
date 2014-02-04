Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaBDJWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:22:21 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62128 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBDJWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:22:13 -0500
MIME-Version: 1.0
In-Reply-To: <20140204091627.GC13529@lee--X1>
References: <1391504833-20022-1-git-send-email-sachin.kamat@linaro.org>
	<20140204091627.GC13529@lee--X1>
Date: Tue, 4 Feb 2014 14:52:12 +0530
Message-ID: <CAK9yfHxeSYNydVn0E3TBETw_Yqjt4ekrjLpRjNoQG6ey=i_WqA@mail.gmail.com>
Subject: Re: [PATCH Resend] mfd: stmpe: Remove unnecessary semicolon
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2014 14:46, Lee Jones <lee.jones@linaro.org> wrote:
>> Semicolon is not necessary after the while statement.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/mfd/stmpe.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
>> index 42ccd0544513..4a91f6771fb8 100644
>> --- a/drivers/mfd/stmpe.c
>> +++ b/drivers/mfd/stmpe.c
>> @@ -706,7 +706,7 @@ static int stmpe1801_reset(struct stmpe *stmpe)
>>               if (!(ret & STMPE1801_MSK_SYS_CTRL_RESET))
>>                       return 0;
>>               usleep_range(100, 200);
>> -     };
>> +     }
>>       return -EIO;
>>  }
>
> Can you re-submit with a new line between it and the return please?

Sure. In a minute :)

-- 
With warm regards,
Sachin
