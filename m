Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbbAZT5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:57:36 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33577 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbAZT5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:57:31 -0500
MIME-Version: 1.0
In-Reply-To: <20150125123316.GA9141@kroah.com>
References: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
	<1421434179-3650-2-git-send-email-mandeep.sandhu@cyaninc.com>
	<20150125123316.GA9141@kroah.com>
Date: Mon, 26 Jan 2015 11:57:30 -0800
Message-ID: <CANg1-_CHd2hG=5Rw7pp8J9VXBYLs-6jZ71YMBBOGksdbAO0Zyw@mail.gmail.com>
Subject: Re: [PATCH 1/4] uio: Simplify the lifetime logic of struct uio_device.
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +
>> +     ret = kobject_set_name(&idev->device.kobj, "uio%d", idev->minor);
>
> dev_set_name()?

There's another instance of use of kobject_set_name in
uio_major_init(). Should I change that too ,or that should be done in
a new (unrelated) patch?

Thanks,
-mandeep


>
>
>
> thanks,
>
> greg k-h
