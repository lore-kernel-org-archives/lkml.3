Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaBZLLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:11:42 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:57879 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaBZLLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:11:40 -0500
MIME-Version: 1.0
In-Reply-To: <20140226092050.GO26722@mwanda>
References: <3395735.omIA0Togio@daeseok-laptop.cloud.net>
	<20140226092050.GO26722@mwanda>
Date: Wed, 26 Feb 2014 20:11:40 +0900
Message-ID: <CAHb8M2DiKuiD4A4-HuNRvkAgZ24uon1ekzAq9OiEE+36qHXcDg@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: make functions as static
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, bergwolf@gmail.com,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually , I saw some code like this file which is seperate line
between return value and function name.
So I didn't make one line of them.

Ok, I will make another patch after merge this one.
Thanks.
Daeseok Youn.

2014-02-26 18:20 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Feb 26, 2014 at 06:17:59PM +0900, Daeseok Youn wrote:
>>
>> These functions are only referenced in this file scope
>> so it can be marked static.
>> And remove space between function name and open parenthesis.
>
> If it's on the same line as a "static" change then it's fine, otherwise
> it should go in a separate patch.
>
> regards,
> dan carpenter
>
>
