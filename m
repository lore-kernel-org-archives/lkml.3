Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966915AbaLKW4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:56:44 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44957 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023AbaLKWuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <20141211144519.GA3509@kroah.com>
References: <1418302030-11428-1-git-send-email-opensource.ganesh@gmail.com>
	<20141211144519.GA3509@kroah.com>
Date: Fri, 12 Dec 2014 06:50:54 +0800
Message-ID: <CADAEsF9GBp15EGDahzx6j=h1nP2D3o66urpu_oZV_gJuZkpMZA@mail.gmail.com>
Subject: Re: [PATCH] fs/debugfs: add get/set for atomic_long types
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg:

2014-12-11 22:45 GMT+08:00 Greg KH <gregkh@linuxfoundation.org>:
> On Thu, Dec 11, 2014 at 08:47:10PM +0800, Ganesh Mahendran wrote:
>> debugfs currently can not create attributes that set/get
>> atomic_long_t values.
>>
>> This patch adds support for this through a new
>> debugfs_create_atomic_long_t() function.
>>
>> Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
>> ---
>>  fs/debugfs/file.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/debugfs.h |    2 ++
>>  2 files changed, 47 insertions(+)
>
> Do you have kernel code that depends on this?

Currently there is no code that is depending on this.
I found there is not a debugfs API to get/set atomic_long_t when I was debuging
mm/zsmalloc. So I sent this patch.

>
> It's the middle of the merge window, so this will have to wait until
> after 3.19-rc1, ok?

It is OK. It is not an urgent patch.
Thanks so much!

>
> thanks,
>
> greg k-h
