Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaCFXVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:21:32 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38273 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaCFXVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:21:31 -0500
MIME-Version: 1.0
In-Reply-To: <20140306195812.GE3403@kroah.com>
References: <6282871.ckfvQvsDb4@daeseok-laptop.cloud.net>
	<20140306195812.GE3403@kroah.com>
Date: Fri, 7 Mar 2014 08:21:30 +0900
Message-ID: <CAHb8M2BBJ5BCyMvnwdv=xYa4h-JArtnCJboUgV1Wu=SfVG5jNA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] staging: cxt1e1: remove unneeded a value
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

Ok.
I will fix it and send again.

Thanks.
Daeseok Youn

2014-03-07 4:58 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Thu, Mar 06, 2014 at 05:12:48PM +0900, Daeseok Youn wrote:
>>
>> It doesn't need to assign name array address to np pointer.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> v2: replace sprintf() with snprintf() and remove memset() call
>> because snprintf() adds a terminating '\0'
>
> Your Subject: does not make sense, please fix it up and resend.
>
> thanks,
>
> greg k-h
