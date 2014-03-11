Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaCKJge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:36:34 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:34138 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaCKJgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:36:32 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
	<CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
	<CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
	<CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
	<CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
Date: Tue, 11 Mar 2014 02:36:31 -0700
X-Google-Sender-Auth: _2FFPgpYihC-EEqkywMyXFw9sM8
Message-ID: <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 9:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I suspect that a lot of 32-bit Linux users want syscall and/or
> sysenter, and Stefani certainly wants the fast timing that the vDSO
> can provide.  Also, presumably __kernel_sigreturn serves some purpose
> :)

Are we talking about the same thing at all?

We're talking about the *COMPAT* vdso, right?

The one you were just told Fedora had never _ever_ enabled? And you
are seriously arguing that "peformance" is relevant, while at the same
time trying to claim that the fact that it DOES NOT WORK on SuSE -
which *did* enable it - is not such a big deal, and that we should
ignore the "don't break user space" rule?

Seriously?

WTF?

                Linus
