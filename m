Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaEWQbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:31:42 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58017 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaEWQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140523155626.GI30445@twins.programming.kicks-ass.net>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
	<1400777250-17335-17-git-send-email-will.deacon@arm.com>
	<537E30AF.4070501@zytor.com>
	<20140523144604.GF21319@arm.com>
	<537F60E0.1060307@zytor.com>
	<20140523145758.GG21319@arm.com>
	<537F6728.3090600@zytor.com>
	<20140523153409.GI21319@arm.com>
	<537F6C85.107@zytor.com>
	<20140523155626.GI30445@twins.programming.kicks-ass.net>
Date: Fri, 23 May 2014 18:31:40 +0200
X-Google-Sender-Auth: eXAU7MX-iXxUoXhzu-Hs50QC8tM
Message-ID: <CAMuHMdW2rVvcORs6tbChxKVoVUnq0j8cfJa+GY6XH_=Tfr+Xcw@mail.gmail.com>
Subject: Re: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor macros
 for writes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 5:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> So the one issue I had with that, is that if one tries to send an email
> to all arch maintainers + linux-arch + linux-kernel, the header gets too
> big and vger chokes and davem slaps you.

The arch maintainers are (supposed to be) on linux-arch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
