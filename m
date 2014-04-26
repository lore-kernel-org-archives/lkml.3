Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaDZA0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:26:46 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40578 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaDZA0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:26:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140425223356.GA7045@kroah.com>
References: <5315479.ef9aFRk9hG@daeseok-laptop.cloud.net>
	<20140425223356.GA7045@kroah.com>
Date: Sat, 26 Apr 2014 09:26:45 +0900
Message-ID: <CAHb8M2C0JM9Qdio6ni87VOj12M15GUZV3KZjAeV2ZsVyFp7Nzg@mail.gmail.com>
Subject: Re: [PATCH] staging: silicom: Add appropriate ifdef conditions in bpctl_mod.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tulinizer@gmail.com, viro@zeniv.linux.org.uk, lorenz@badgers.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-26 7:33 GMT+09:00, Greg KH <gregkh@linuxfoundation.org>:
> On Mon, Apr 07, 2014 at 12:03:41PM +0900, Daeseok Youn wrote:
>>
>> The bp_proc_create() can be called if BP_PROC_SUPPORT is defined.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/silicom/bpctl_mod.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/staging/silicom/bpctl_mod.c
>> b/drivers/staging/silicom/bpctl_mod.c
>> index 6b9365b..5a3d758 100644
>> --- a/drivers/staging/silicom/bpctl_mod.c
>> +++ b/drivers/staging/silicom/bpctl_mod.c
>> @@ -119,7 +119,10 @@ static void if_scan_init(void);
>>
>>  static int bypass_proc_create_dev_sd(struct bpctl_dev
>> *pbp_device_block);
>>  static int bypass_proc_remove_dev_sd(struct bpctl_dev
>> *pbp_device_block);
>> +
>> +#ifdef BP_PROC_SUPPORT
>>  static int bp_proc_create(void);
>> +#endif
>
> No, this code should just be removed, right?
Yes, someone sent a patch for this.

Regards,
Daeseok Youn
>
>
