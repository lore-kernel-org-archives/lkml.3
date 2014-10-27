Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaJ0Jnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:43:55 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:43874 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaJ0Jnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:43:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVb8k_6zHm0deAWUKcKNfTpt2VL3RkJuv-99SCRwtUQEQ@mail.gmail.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
	<1414139071-3818-5-git-send-email-lftan@altera.com>
	<CAMuHMdVb8k_6zHm0deAWUKcKNfTpt2VL3RkJuv-99SCRwtUQEQ@mail.gmail.com>
Date: Mon, 27 Oct 2014 17:43:50 +0800
X-Google-Sender-Auth: F1409Y0H0TLelBNmbqrJ_esgoRo
Message-ID: <CAFiDJ5_mwgtqsXN1oQ=FGNWZbB+escVFqEPYkuOPOVDTuWev2A@mail.gmail.com>
Subject: Re: [PATCH v5 04/29] nios2: Exception handling
From: Ley Foon Tan <lftan@altera.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 5:15 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Oct 24, 2014 at 10:24 AM, Ley Foon Tan <lftan@altera.com> wrote:
>> --- /dev/null
>> +++ b/arch/nios2/kernel/entry.S
>> @@ -0,0 +1,559 @@
>> +/*
>> + * linux/arch/nios2/kernel/entry.S
>> + *
>> + * Copyright (C) 2013-2014  Altera Corporation
>> + * Copyright (C) 2009, Wind River Systems Inc
>> + *
>> + * Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
>> + *
>> + * Based on:
>> + *
>> + * linux/arch/nios2/kernel/entry.S
>
> And here you did one s/m68k/nios2/ too much ;-)
>
> As this doesn't seem to come from a single file
> "Based on the various m68k entry.S files"?
Good catch. Will remove this line.

Regards
Ley Foon
