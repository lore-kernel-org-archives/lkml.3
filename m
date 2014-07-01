Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbaGASiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:38:02 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35912 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068AbaGASiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:38:01 -0400
MIME-Version: 1.0
In-Reply-To: <53AE0519.8050909@zytor.com>
References: <1402463064-31697-1-git-send-email-yinghai@kernel.org>
	<53AE0519.8050909@zytor.com>
Date: Tue, 1 Jul 2014 11:38:00 -0700
X-Google-Sender-Auth: DpUSczMkvNT_Ar8TH0b_JbvG0Q4
Message-ID: <CAE9FiQW2YsVYdnPDw0oYk=4u1Fv_7vntUom=K5rvD9m+4DzH+g@mail.gmail.com>
Subject: Re: [PATCH] x86: Find correct 64 bit ramdisk address for microcode
 early update
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 4:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/10/2014 10:04 PM, Yinghai Lu wrote:
>> When using kexec with 64bit kernel, bzImage and ramdisk could be
>> loaded above 4G. We need this to get correct ramdisk adress.
>>
>> Make get_ramdisk_image() global and use it for early microcode updating.
>> Also make it to take boot_params pointer for different usage.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Please update your patch description to explain what "different usage"
> you have in mind here.

oh, no. I should drop that line. That is left over for parsing
acpi/srat patchset.

Thanks

Yinghai
