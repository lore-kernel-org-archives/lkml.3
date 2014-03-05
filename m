Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaCEAzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:55:16 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35768 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaCEAzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:55:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140305003505.GA28196@kroah.com>
References: <2842786.yy4V63h1Bd@daeseok-laptop.cloud.net>
	<20140305003505.GA28196@kroah.com>
Date: Wed, 5 Mar 2014 09:55:14 +0900
Message-ID: <CAHb8M2D8miCPsse4twZxqtSaOAv4bKncUWcm47JXvfKxQZodVw@mail.gmail.com>
Subject: Re: [PATCH 5/7] staging: cxt1e1: fix checkpatch errors with open
 brace '{'
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, Shaun Laing <shaun@xresource.ca>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        "ying.xue" <ying.xue@windriver.com>,
        David Miller <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, greg

I already resend patch 4 and 5. :-)

It had a bug which is noticed by Dan.

I tried to fix assignment in if condition and missed curly brace in inner loop.
So I fixed that bug and resend patch 4. And patch 5 is rebased after
fixing patch 4.

And I tested to apply these patch to staging-next branch from mailing list.
Please check.

Thanks.
Daeseok Youn.

2014-03-05 9:35 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Tue, Mar 04, 2014 at 11:10:44AM +0900, Daeseok Youn wrote:
>>
>> clean up checkpatch.pl error in linux.c:
>>  ERROR: that open brace { should be on the previous line
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/cxt1e1/linux.c |   67 ++++++++++++---------------------------
>>  1 files changed, 21 insertions(+), 46 deletions(-)
>
> As patch 4 can't be applied, I can't apply these either, please resend
> the rest of the series when you fix them up.
>
> thanks,
>
> greg k-h
