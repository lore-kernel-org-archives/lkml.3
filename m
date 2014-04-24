Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaDXGEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:04:42 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:45246 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaDXGEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:04:40 -0400
MIME-Version: 1.0
In-Reply-To: <201404231423.51221.arnd@arndb.de>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<CAFiDJ58oeUtXR_gqud9pw55wojY6PJRQp8PAyEfpDL_Let7u=Q@mail.gmail.com>
	<CAMuHMdX1xxuWhhBH0TKMtSEek5QDYchNVtC9QKoFQGr454_GVA@mail.gmail.com>
	<201404231423.51221.arnd@arndb.de>
Date: Thu, 24 Apr 2014 14:04:39 +0800
X-Google-Sender-Auth: DCPaiMSTvr0ChYTVk2zqr44zKxE
Message-ID: <CAFiDJ5-GbGquUmYkbtYZ7m+tT8-UHphR-4smtri1rOdadsRSnw@mail.gmail.com>
Subject: Re: [PATCH 04/28] nios2: Exception handling
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 8:23 PM, Arnd Bergmann <arnd@arndb.de> wrote:

>> >> We really shouldn't be doing new architecture specific procfs files
>> >> any more. I suggest you drop this one for now, and add back the
>> >> functionality using perf or ftrace at a later point.
>> >
>> > Okay, will remove this.
>>
>> MIPS and powerpc handle this through debugfs, cfr.
>> arch/mips/kernel/unaligned.c and arch/powerpc/kernel/traps.c.
>
> Ah, right, that would work too. Being able to use perf from user
> space sounds more flexible though. It's certainly something that
> can be decided later.
Yes, we can add this back through debugfs or perf in later.

Regards
Ley Foon
