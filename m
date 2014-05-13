Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbaEMJ2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:28:10 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54521 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378AbaEMJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:08 -0400
MIME-Version: 1.0
In-Reply-To: <5371E44E.20509@imgtec.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<1399971885-4413-1-git-send-email-lftan@altera.com>
	<5371E44E.20509@imgtec.com>
Date: Tue, 13 May 2014 17:28:07 +0800
X-Google-Sender-Auth: Ajc_3khvHukLFPUIGFlzfi24qQM
Message-ID: <CAFiDJ59yCxcL+g7K05AWoaDiR_hmLdW6R8Dz3sOUwTGmug4YoQ@mail.gmail.com>
Subject: Re: [PATCH 12/25] metag: Add 32 bit time_t and clock_t
From: Ley Foon Tan <lftan@altera.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>, linux-metag@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 5:22 PM, James Hogan <james.hogan@imgtec.com> wrote:
> Hi,
>
> On 13/05/14 10:04, Ley Foon Tan wrote:
>> Override time_t and clock_t in include/uapi/asm-generic.
>>
>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>> ---
>>  arch/metag/include/asm/Kbuild             |  1 -
>>  arch/metag/include/uapi/asm/Kbuild        |  1 +
>>  arch/metag/include/uapi/asm/posix_types.h | 17 +++++++++++++++++
>>  3 files changed, 18 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/metag/include/uapi/asm/posix_types.h
>>
>> diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
>> index c29ead8..5a97e0d6 100644
>> --- a/arch/metag/include/asm/Kbuild
>> +++ b/arch/metag/include/asm/Kbuild
>> @@ -31,7 +31,6 @@ generic-y += param.h
>>  generic-y += pci.h
>>  generic-y += percpu.h
>>  generic-y += poll.h
>> -generic-y += posix_types.h
>>  generic-y += preempt.h
>>  generic-y += scatterlist.h
>>  generic-y += sections.h
>> diff --git a/arch/metag/include/uapi/asm/Kbuild b/arch/metag/include/uapi/asm/Kbuild
>> index 84e09fe..1542689 100644
>> --- a/arch/metag/include/uapi/asm/Kbuild
>> +++ b/arch/metag/include/uapi/asm/Kbuild
>> @@ -3,6 +3,7 @@ include include/uapi/asm-generic/Kbuild.asm
>>
>>  header-y += byteorder.h
>>  header-y += ech.h
>> +header-y += posix_types.h
>
> I don't think you need this. The file
> include/uapi/asm-generic/Kbuild.asm which is included at the top of each
> arches uapi/asm/Kbuild already has it.
> (Admittedly there's already a lot of duplication of these that should
> probably be fixed at some point).
>
> Other than that it looks okay to me.
Okay, will remove this.

Thanks.
Regards
Ley Foon
