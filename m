Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaCFXRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:17:18 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:53747 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaCFXRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:17:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140306195716.GD3403@kroah.com>
References: <2109601.U7a2ESYcJ8@daeseok-laptop.cloud.net>
	<20140306195716.GD3403@kroah.com>
Date: Fri, 7 Mar 2014 08:17:16 +0900
Message-ID: <CAHb8M2A4C-FX0RBuuH8iORi+O-TV8nZCAHc9dmXLW6Rs-ZvC6g@mail.gmail.com>
Subject: Re: [PATCH 4/7 v3] staging: cxt1e1: fix checkpatch error 'assignment
 in if condition'
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, Shaun Laing <shaun@xresource.ca>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        David Miller <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for confusing you.
Actually 1-3 patches already merged to staging-next branch.

And then I had a request resending the rest of the series.
So I just sent 4-7 again. Sorry, I should rebase these patches and
make a series newly.

I will send patches again properly.
I think this patches need to rebase current staging-next branch.

Thanks.
Daeseok Youn.

2014-03-07 4:57 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, Mar 05, 2014 at 10:21:01AM +0900, Daeseok Youn wrote:
>>
>> checkpatch.pl error in linux.c:
>>  ERROR: do not use assignment in if condition
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/cxt1e1/linux.c |   31 +++++++++++++++++++------------
>>  1 files changed, 19 insertions(+), 12 deletions(-)
>
> I don't see patches 1-3 here, so I'm dropping this whole series.
>
> I do not have any short-term, or long-term, memory about patches I've
> rejected / approved / discussed, as I deal with thousands of them every
> week.  You need to be explicit as to what is going on, and don't try to
> confused me.
>
> Please resend properly.
>
> greg k-h
