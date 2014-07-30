Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaG3KvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:51:01 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:47308 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaG3Ku7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140730090101.GD10301@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-6-git-send-email-lftan@altera.com>
	<20140730090101.GD10301@distanz.ch>
Date: Wed, 30 Jul 2014 18:50:58 +0800
X-Google-Sender-Auth: 2Lt6QDzjzNTxhrMCU92MIKSc0bE
Message-ID: <CAFiDJ5_d4zhV6m8BzqWC6vTErYv_S1QBQqkH=55wqQjUrK-pwg@mail.gmail.com>
Subject: Re: [PATCH v2 05/29] nios2: Memory management
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 5:01 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
> On 2014-07-15 at 10:45:32 +0200, Ley Foon Tan <lftan@altera.com> wrote:
>> This patch contains the initialisation of the memory blocks, MMU
>> attributes and the memory map.
>>
>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>> ---
>>  arch/nios2/include/asm/mmu.h     |  18 +++
>>  arch/nios2/include/asm/page.h    | 113 +++++++++++++++++++
>>  arch/nios2/include/asm/uaccess.h | 233 +++++++++++++++++++++++++++++++++++++++
>>  arch/nios2/mm/init.c             | 142 ++++++++++++++++++++++++
>>  arch/nios2/mm/uaccess.c          | 162 +++++++++++++++++++++++++++
>>  5 files changed, 668 insertions(+)
>>  create mode 100644 arch/nios2/include/asm/mmu.h
>>  create mode 100644 arch/nios2/include/asm/page.h
>>  create mode 100644 arch/nios2/include/asm/uaccess.h
>>  create mode 100644 arch/nios2/mm/init.c
>>  create mode 100644 arch/nios2/mm/uaccess.c
>
> [...]
>
>> diff --git a/arch/nios2/include/asm/page.h b/arch/nios2/include/asm/page.h
>> new file mode 100644
>> index 0000000..b89c1d6
>> --- /dev/null
>> +++ b/arch/nios2/include/asm/page.h
>> @@ -0,0 +1,113 @@
>> +/*
>> + * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
>> + * Copyright (C) 2004 Microtronix Datacom Ltd.
>> + *
>> + * MMU support based on asm/page.h from mips which is:
>> + *
>> + * Copyright (C) 1994 - 1999, 2000, 03 Ralf Baechle
>> + * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
>> + *
>> + * NOMMU support based on asm/page.h from m68knommu.
>
> You might want to remove this line to avoid confusion, since NOMMU is
> not supported anymore in this submission of the NIOS II port.

Okay.

Thanks.

Regards
Ley Foon
