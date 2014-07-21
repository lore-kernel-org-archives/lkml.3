Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaGUKB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:01:56 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61509 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaGUKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <CACVxJT-C6_7hVTfrGQ7fH1VbBTQF9tJ1raNU5QuA2BR1J1sY5Q@mail.gmail.com>
References: <CACVxJT-C6_7hVTfrGQ7fH1VbBTQF9tJ1raNU5QuA2BR1J1sY5Q@mail.gmail.com>
Date: Mon, 21 Jul 2014 13:01:50 +0300
Message-ID: <CACVxJT_8dRxKpOvt=t+t=zUY7dqxwkg-rSZOCbOvmvNWEhpCiQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] fs.h: Whitespace neatening
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case any new people are reading this thread.

If checkpatch.pl says something, it is largely irrelevant and not
worth sending as is.
Save yourself some time and skip this stage completely.

  Alexey

On Mon, Jul 21, 2014 at 12:58 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> -#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
>> +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
>
>> -#define KERNEL_READ (READ|REQ_KERNEL)
>> -#define KERNEL_WRITE (WRITE|REQ_KERNEL)
>> +#define KERNEL_READ (READ | REQ_KERNEL)
>> +#define KERNEL_WRITE (WRITE | REQ_KERNEL)
>
> I understand that you have no clue about what is important and what is not,
> but at least do no pollute git-blame with your prototype and other oh so
> important changes.
>
> Sincerely Yours, A
