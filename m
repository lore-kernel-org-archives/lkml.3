Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaCQX1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:27:06 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53409 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaCQX1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140317212314.GA3112@kroah.com>
References: <1858518.8JZ4tELMNS@daeseok-laptop.cloud.net>
	<20140317212314.GA3112@kroah.com>
Date: Tue, 18 Mar 2014 08:27:03 +0900
Message-ID: <CAHb8M2DgBNJqTKC1B+QYA5YX9NAoMJ9-MFG3NB7fEc3mfiXPwA@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: cxtie1: remove unneeded mkret() calls
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: nandini h <nandu.hgowda@gmail.com>, devel <devel@driverdev.osuosl.org>,
        Shaun Laing <shaun@xresource.ca>,
        "sachin.kamat" <sachin.kamat@linaro.org>, gang.chen@asianux.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        "ying.xue" <ying.xue@windriver.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. I will rebase this patch in staging-next branch and send it again.

Thanks.
Daeseok Youn.

2014-03-18 6:23 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Mon, Mar 10, 2014 at 08:54:18AM +0900, Daeseok Youn wrote:
>>
>> The mkret() change a value of error from positive to
>> negative. This patch is modified to return negative value
>> when it failed. It doesn't need to call with function
>> for changing from positive to negative.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/cxt1e1/linux.c     |   72 +++++++++++++----------------------
>>  drivers/staging/cxt1e1/musycc.c    |    2 +-
>>  drivers/staging/cxt1e1/pmcc4_drv.c |   40 ++++++++++----------
>>  3 files changed, 48 insertions(+), 66 deletions(-)
>
> This patch no longer applies to my tree, can you refresh it and resend?
