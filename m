Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab3EOOqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:46:08 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53508 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979Ab3EOOqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <51935981.3010808@amd.com>
References: <51935981.3010808@amd.com>
Date: Wed, 15 May 2013 07:46:05 -0700
X-Google-Sender-Auth: rjB1cO94gAcjfyHgaoQe9umyi8k
Message-ID: <CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com>
Subject: Re: 3.9 breaks EFI boot on E350
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 2:46 AM, Christian König
<christian.koenig@amd.com> wrote:
> Hi guys,
>
> the following commit breaks booting my E350 based test system in EFI mode:
>
>> commit 8d57470d8f859635deffe3919d7d4867b488b85a
>> Author: Yinghai Lu <yinghai@kernel.org>
>> Date:   Fri Nov 16 19:38:58 2012 -0800
>>
>>     x86, mm: setup page table in top-down
>
>
> This commit was supposed to fix it but obviously there still seem to be some
> bugs left in 3.9
>
>> commit 98e7a989979b185f49e86ddaed2ad6890299d9f0
>> Author: Yinghai Lu <yinghai@kernel.org>
>> Date:   Wed Mar 6 20:18:21 2013 -0800
>>
>>     x86, mm: Make sure to find a 2M free block for the first mapped area
>>
>>     Henrik reported that his MacAir 3.1 would not boot with
>>
>>     | commit 8d57470d8f859635deffe3919d7d4867b488b85a
>>     | Date:   Fri Nov 16 19:38:58 2012 -0800
>>     |
>>     |    x86, mm: setup page table in top-down
>>
>

can you send out working boot log with memory map?

you need to boot system with "debug ignore_loglevel"

Thanks

Yinghai
