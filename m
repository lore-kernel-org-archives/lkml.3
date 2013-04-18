Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967656Ab3DRJzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:55:35 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57040 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966743Ab3DRJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130418094629.GC21719@pd.tnic>
References: <20130412181956.GA13099@pd.tnic>
	<516A7760.7030907@kernel.org>
	<20130414110320.GB20547@pd.tnic>
	<20130416161852.GH5332@pd.tnic>
	<20130417232507.GC31059@amt.cnet>
	<20130418094629.GC21719@pd.tnic>
Date: Thu, 18 Apr 2013 11:55:33 +0200
X-Google-Sender-Auth: NsNo-bBC7F9wJpDwDbSUr7xVTyA
Message-ID: <CAMuHMdVmeMfXKuO9FjHWjS80vUWqc-y0NA8YJruwtkz7QeQosA@mail.gmail.com>
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:46 AM, Borislav Petkov <bp@alien8.de> wrote:
> ok, maybe I wasn't clear enough. My proposal was to actually add all (or
> maybe not *all* of them, but most) those selects above to the KVM_GUEST
> config option. Because, you very probably want to select all that stuff
> above anyway if you want to build a kvm guest kernel, no?
>
> IOW, something which says "Enable KVM guest support" should enable all
> the stuff needed for that.

"needed" yes,
"probably" no, as there's no way to disable them if they're selected
unconditionally.

Perhaps you can make the "probably" selects depend on !EXPERT to fix this?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
