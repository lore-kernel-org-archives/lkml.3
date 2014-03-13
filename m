Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaCMVsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:48:35 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59166 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaCMVse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:48:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140313211016.GC3793@tassilo.jf.intel.com>
References: <CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com>
	<CA+55aFyOp6V_tE-sXKVi+=6yVwHQb0sLWSNbk=N7KbhBrx9QhA@mail.gmail.com>
	<CA+55aFyCSL==4Ff4JT3uFKN_28mz92ef1L67-4OUGqHZ8HXUhg@mail.gmail.com>
	<CALCETrVa2XPc5JBDbDdH1ciavi2tuqwBf7picE4TVf69n_PcKw@mail.gmail.com>
	<CA+55aFwDn3zA0gEn2r3nJVPWuv-pLYyrj4=8_gt1xFTd2g_Dwg@mail.gmail.com>
	<8cf1b00c-ef93-4ad0-97f7-53888b50d160@email.android.com>
	<CA+55aFxWsm=P5h1o=BNrwkcy2ZadFsVxpegxJ0rskPVcmo_Ljw@mail.gmail.com>
	<53220DEB.6030902@zytor.com>
	<20140313210010.GB3793@tassilo.jf.intel.com>
	<53221D78.7000606@zytor.com>
	<20140313211016.GC3793@tassilo.jf.intel.com>
Date: Thu, 13 Mar 2014 14:48:33 -0700
X-Google-Sender-Auth: 92lL30NLFiLGUT4jsxH_HFzVrW8
Message-ID: <CA+55aFxcV-aOKceY8zx6ekB1APzAo=DDb4fM86gZ=V+z1dtdYA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 2:10 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> Doesn't cripple it in any way.
>
> Forcing it to int 0x80 does however.

No it doesn't.

It runs fine. No crippling.

If you are silly enough to run a eight-year-old distribution, and then
upgrade just the kernel, you'll run a bit slower. So what?

We care about it *working*. We don't care about optimal performance of
an old distribution. People can upgrade if they want.

              Linus
