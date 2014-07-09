Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaGIEYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:24:10 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33053 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaGIEYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <5395860E.3070000@mev.co.uk>
References: <1402149415-20037-1-git-send-email-a.s.protopopov@gmail.com>
	<5395860E.3070000@mev.co.uk>
Date: Wed, 9 Jul 2014 08:24:06 +0400
X-Google-Sender-Auth: MnFZJFo0Ad0Q7iKVkzBKZcG89BU
Message-ID: <CAGn_itzc_Lnu6qNTin6eDcBirJE3mHEp2_Ex+H6tqLA2OUBBjw@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: check the return value of kobject_set_name
From: Anton Protopopov <a.s.protopopov@gmail.com>
To: gregkh <gregkh@linuxfoundation.org>
Cc: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, abbotti <abbotti@mev.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-09 14:01 GMT+04:00 Ian Abbott <abbotti@mev.co.uk>:
> On 2014-06-07 14:56, Anton Protopopov wrote:
>>
>> Added a check of the return value of the kobject_set_name function.
>>
>> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
>> ---
>>   drivers/staging/comedi/comedi_fops.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>
>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

This patch was lost, I guess?

>
> --
> -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
> -=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
