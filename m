Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaCDKLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:11:06 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:36025 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbaCDKLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:11:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140304084555.GS26722@mwanda>
References: <2825545.2YpN0JuVSn@daeseok-laptop.cloud.net>
	<20140304084555.GS26722@mwanda>
Date: Tue, 4 Mar 2014 19:10:59 +0900
Message-ID: <CAHb8M2A39saK7saiD9RCpRBE+6NZsMyfy+2feV149Q1hFWrocQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] staging: cxt1e1: Fix line length over 80 characters
 in linux.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, shaun@xresource.ca,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        dulshani.gunawardhana89@gmail.com, ying.xue@windriver.com,
        davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for review.
Ok. I Will fix later.

Daeseok Youn
2014-03-04 17:45 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, Mar 04, 2014 at 11:08:46AM +0900, Daeseok Youn wrote:
>>
>> clean up checkpatch.pl warnings:
>>  WARNING: Line length over 80 characters
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/cxt1e1/linux.c |   48
>> +++++++++++++++++++++++++--------------
>>  1 files changed, 31 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/staging/cxt1e1/linux.c
>> b/drivers/staging/cxt1e1/linux.c
>> index 17d73f4..579e68e 100644
>> --- a/drivers/staging/cxt1e1/linux.c
>> +++ b/drivers/staging/cxt1e1/linux.c
>> @@ -31,7 +31,7 @@
>>  #include "pmcc4_private.h"
>>  #include "sbeproc.h"
>>
>> -/*****************************************************************************************
>> +/*******************************************************************************
>
> This should just be:
>
> /*
>  *
>  *
>
> Not ************************************************** etc.
>
> Fix in a later patch if you want.
>
> regards,
> dan carpenter
>
>
>
