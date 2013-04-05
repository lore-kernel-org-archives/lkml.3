Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161514Ab3DEDJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 23:09:48 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:50044 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161277Ab3DEDJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 23:09:47 -0400
MIME-Version: 1.0
In-Reply-To: <2084826.BkfVPXvXDZ@skinner.arch.suse.de>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
	<2084826.BkfVPXvXDZ@skinner.arch.suse.de>
Date: Thu, 4 Apr 2013 20:09:46 -0700
X-Google-Sender-Auth: HyWb7PTQ2n_gur9d2s7PG6g7iG0
Message-ID: <CAE9FiQXE5T=8RJ0FdrMfiTwZ_NDBwjsOM0q_SePWsuQ3tXMz6Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] x86, ACPI, numa: Parse numa info early
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 7:28 PM, Thomas Renninger <trenn@suse.de> wrote:
> On Thursday, April 04, 2013 04:46:04 PM Yinghai Lu wrote:
>> One commit that tried to parse SRAT early get reverted before v3.9-rc1.
>>
>> | commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
>> | Author: Tang Chen <tangchen@cn.fujitsu.com>
>> | Date:   Fri Feb 22 16:33:44 2013 -0800
>> |
>> |    acpi, memory-hotplug: parse SRAT before memblock is ready
>>
>> It broke several things, like acpi override and fall back path etc.
>>
>> This patchset is clean implementation that will parse numa info early.
>
> I tried acpi table overriding, but it did not work for me.
> In your tree there seem to miss acpi initrd overriding doku:
> Documentation/acpi/initrd_table_override.txt

http://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/tree/Documentation/acpi/initrd_table_override.txt?h=for-x86-mm

> And your tree is 3.6.0-rc6-default+ based, right?

It is in for-x86-mm branch, should be 3.9-rc5 based.

http://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/tree/Documentation/acpi/initrd_table_override.txt?h=for-x86-mm

can you try

git checkout -b for-x86-mm origin/for-x86-mm

Thanks

Yinghai
