Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaCIN0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 09:26:47 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:44003 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaCIN0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 09:26:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140309063800.GA19386@kroah.com>
References: <3080766.8PpGkKSQoC@daeseok-laptop.cloud.net>
	<20140309063800.GA19386@kroah.com>
Date: Sun, 9 Mar 2014 22:26:45 +0900
Message-ID: <CAHb8M2AZMdEDCcCKZ9AhVYNJPseiJWwsxQDS_Kni9UajUc4Mkw@mail.gmail.com>
Subject: Re: [PATCH 3/4] staging: cxtie1: remove unneeded mkret() calls
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, shaun@xresource.ca, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org, dulshani.gunawardhana89@gmail.com,
        ying.xue@windriver.com, davem@davemloft.net, dan.carpenter@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. I will check and send it again.

Thanks.
Daeseok Youn.

2014-03-09 15:38 GMT+09:00, Greg KH <gregkh@linuxfoundation.org>:
> On Fri, Mar 07, 2014 at 09:03:04AM +0900, Daeseok Youn wrote:
>>
>> The mkret() change a value of error from positive to
>> negative. This patch is modified to return negative value
>> when it failed. It doesn't need to call with function
>> for changing from positive to negative.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/cxt1e1/linux.c     |   72
>> +++++++++++++----------------------
>>  drivers/staging/cxt1e1/musycc.c    |    2 +-
>>  drivers/staging/cxt1e1/pmcc4_drv.c |   40 ++++++++++----------
>>  3 files changed, 48 insertions(+), 66 deletions(-)
>
> This patch doesn't apply to my tree, can you refresh it, and patch 4 and
> resend?
>
> thanks,
>
> greg k-h
>
