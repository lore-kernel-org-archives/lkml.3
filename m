Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3CRSFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:05:46 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49223 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3CRSFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130313.053145.2200448840921851390.davem@davemloft.net>
References: <1363111995-26866-1-git-send-email-silviupopescu1990@gmail.com>
	<20130313.053145.2200448840921851390.davem@davemloft.net>
Date: Mon, 18 Mar 2013 20:05:42 +0200
Message-ID: <CAPWTe+JzznuWYKksAfxkD=u9kv8DuAF4v2AWVxd2OUeDtCYKBA@mail.gmail.com>
Subject: Re: [PATCH] bluetooth: use PTR_RET instead of IS_ERR + PTR_ERR
From: Silviu Popescu <silviupopescu1990@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-bluetooth@vger.kernel.org, marcel@holtmann.org, gustavo@padovan.org,
        johan.hedberg@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 11:31 AM, David Miller <davem@davemloft.net> wrote:
> From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> Date: Tue, 12 Mar 2013 20:13:15 +0200
>
>> @@ -590,10 +590,7 @@ int __init bt_sysfs_init(void)
>>       bt_debugfs = debugfs_create_dir("bluetooth", NULL);
>>
>>       bt_class = class_create(THIS_MODULE, "bluetooth");
>> -     if (IS_ERR(bt_class))
>> -             return PTR_ERR(bt_class);
>> -
>> -     return 0;
>> +     return PTR_RET(bt_class)
>
> Don't bother submitting patches you aren't even going to try
> to compile.
>
> I'm rejecting all of your current submissions.  Resubmit them
> when you feel like typing 'make' from time to time.
>
>

Sorry for the trouble caused and sorry for the late reply.
That being said, I'd like to understand a bit better what exactly I messed up.
I've just pulled the latest revision of the mainline kernel and made
the changes in this patch.
I've tried with make defconfig (which would be x86_64_defconfig in my
case), followed by
make menuconfig to select the bluetooth options and make allyesconfig.
Both defconfig and allyesconfig compile successfully on my system.
Would you be so kind as to tell me what error you have encountered?
Or perhaps enlighten me as to what I'm still doing wrong. I'd like to
learn from my mistakes.

Thanks,
Silviu Popescu
