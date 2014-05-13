Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbaEMJXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:23:51 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49933 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaEMJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:23:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVyCXXZgmEVkbo+cZfQfYspZO4SH+iV-zCLq-6G4m47QQ@mail.gmail.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<CAMuHMdVyCXXZgmEVkbo+cZfQfYspZO4SH+iV-zCLq-6G4m47QQ@mail.gmail.com>
Date: Tue, 13 May 2014 17:23:48 +0800
X-Google-Sender-Auth: BdHy86GjFV5ymvqbuC5WevXeHTo
Message-ID: <CAFiDJ58r_X1m4NoyRBu2EGqrY22Q2VuJmqBFY7m49ECR+aQk7Q@mail.gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
From: Ley Foon Tan <lftan@altera.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 5:10 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi,
>
> On Tue, May 13, 2014 at 10:57 AM, Ley Foon Tan <lftan@altera.com> wrote:
>> This patchset change default time_t and clock_t to 64 bit in
>> include/uapi/asm-generic/posix_types.h. The existing 32 bit architectures override
>> these define to 32 bit in arch posix_types.h.
>
> Thanks for your series!
>
>> Ley Foon Tan (25):
>>   asm-generic: Change time_t and clock_t to 64 bit
>
> For bisectability, this should be the last change, not the first.
Noted, will put this as last patch in next revision.
Thanks.

Regards
Ley Foon
