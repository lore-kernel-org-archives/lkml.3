Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3AONkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:40:04 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:62809 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab3AONkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:40:02 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E1A6F0BED@BGMAIL02.nvidia.com>
References: <CA+icZUV=-=DALJRpzrmKrC6oK-CwCyRbHE1VmjrLfmGcemx2JQ@mail.gmail.com>
	<D958900912E20642BCBC71664EFECE3E6E1A6F0BED@BGMAIL02.nvidia.com>
Date: Tue, 15 Jan 2013 14:40:01 +0100
Message-ID: <CA+icZUUxURMi6Qc+FHCa_sP8LPH4pyOJwTZzv11MJZ9ZdEkxkA@mail.gmail.com>
Subject: Re: linux-next: Why no Tree for Jan 15?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 2:34 PM, Venu Byravarasu <vbyravarasu@nvidia.com> wrote:
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Sedat Dilek
>> Sent: Tuesday, January 15, 2013 6:51 PM
>> To: Stephen Rothwell
>> Cc: linux-next; LKML
>> Subject: linux-next: Why no Tree for Jan 15?
>>
>> Hi Stephen,
>>
>> any reason why there is no Linux-Next for today?
>
> Seems Stephen created tree but did not announce it via mail, because
> when I synced to linux-next today, am seeing below commit from him:
>
> commit 371450db41f86a409fc0b6da7b3b8ab9b55f617c
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Tue Jan 15 14:25:58 2013 +1100
>
>     Add linux-next specific files for 20130115
>
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>

OK, I see.
This release has two important fixes for me in char-misc-next (mei
driver) and "mm: fix BUG on madvise early failure".
Thanks for the information!

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=12dd7dcc8e3159591dc8d63d75eefa6f049cf0b1

> Thanks,
> Venu
>
>
>>
>> Regards,
>> - Sedat -
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
