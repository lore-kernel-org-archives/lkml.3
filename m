Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaEIN5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:57:01 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36240 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaEIN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140509104202.GG4963@mwanda>
References: <20140509100220.GA6446@devel.8.8.4.4>
	<20140509104202.GG4963@mwanda>
Date: Fri, 9 May 2014 22:56:59 +0900
Message-ID: <CAHb8M2A4WShQH7q_rrx_DqPJE-9-Bn1_LRXh8MJ_syvPBqupSg@mail.gmail.com>
Subject: Re: [PATCH 1/5] staging: cxt1e1: Fix no spaces at the start of a line
 in musycc.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-09 19:42 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, May 09, 2014 at 07:02:20PM +0900, Daeseok Youn wrote:
>> clean up checkpatch.pl warning:
>>  WARNING: please no spaces at the start of a line in
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>
>> -#ifdef RLD_TRANS_DEBUGx
>> -    if (1 || cxt1e1_log_level >= LOG_MONITOR2)
>> +#ifdef RLD_TRANS_DEBUG
>> +	if (1 || cxt1e1_log_level >= LOG_MONITOR2)
>>  #else
>
> You fixed a typo here.  I don't care about it, because we are going to
> delete this code anyway.  But normally I would ask you to redo the patch
> because it should be done separately, and it should be described in the
> changelog instead of slipped in secretly.
Oh.. I didn't know that fixed typo is in this patch. :-)
>
> But in this case, I don't care so you got lucky.
Thanks.

Regards,
Daeseok Youn
>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> regards,
> dan carpenter
>
>
