Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3FCJNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:13:11 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61357 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3FCJNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <51AC5D7C.2000905@asianux.com>
References: <51A6F0C6.9050806@asianux.com>
	<m2a9ndndu5.fsf@linux-m68k.org>
	<51A70C10.6000408@asianux.com>
	<CAMuHMdWOxh_YvQyid-PiN7FsM=OC=0YWOzJb86pKaQn3HrjaQw@mail.gmail.com>
	<51AC5D7C.2000905@asianux.com>
Date: Mon, 3 Jun 2013 11:13:06 +0200
X-Google-Sender-Auth: u6hWrOT4ZRHDklYK4XgT2cqCAoA
Message-ID: <CAMuHMdXrxAajOqfZd4iQRC2pKHE8KAZOVsZRfeyMWLHRt0NVUg@mail.gmail.com>
Subject: Re: [PATCH v2] arch: m68k: math-emu: unsigned issue, 'unsigned long'
 will never be less than zero
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 11:10 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> Thanks, applied and queued for 3.11!
>>
>
> Thank you too, and pardon: what is '3.11' ?  :-)

Linux v3.11.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
