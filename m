Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbaDBIBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:01:03 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35797 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaDBIBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <201404011852.s31Iqh12025199@terminus.zytor.com>
References: <201404011852.s31Iqh12025199@terminus.zytor.com>
Date: Wed, 2 Apr 2014 10:01:00 +0200
X-Google-Sender-Auth: ezByIGvB_B8VXrE-xUNsDISdcbQ
Message-ID: <CAMuHMdUyG1fnhiTCiVpJd2m=DuYGMY92ydGVJhYw1ZCGtzxmRg@mail.gmail.com>
Subject: Re: [GIT PULL] x86 old platform removal for v3.15
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mdr@sgi.com, Ingo Molnar <mingo@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, pazke@donpac.ru,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 8:52 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> David Rientjes (2):
>       x86, apic: Remove support for ia32-based Unisys ES7000
>       x86, apic: Remove support for IBM Summit/EXA chipset
>
> H. Peter Anvin (2):
>       x86, platforms: Remove SGI Visual Workstation
>       x86, platforms: Remove NUMAQ

Nice try on April the 1st! Nobody's gonna notice ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
