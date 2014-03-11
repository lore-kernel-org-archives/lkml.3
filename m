Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaCKQyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:54:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:32160 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaCKQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,631,1389772800"; 
   d="scan'208";a="489900308"
Message-ID: <531F3F57.8090105@linux.intel.com>
Date: Tue, 11 Mar 2014 09:52:39 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net> <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com> <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com> <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com> <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com> <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com> <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com> <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com> <531F365B.4060000@linux.intel.com> <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com> <531F3D02.30706@linux.intel.com> <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com> <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>
In-Reply-To: <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 09:50 AM, Andy Lutomirski wrote:
> Looking forward, would it be reasonable to have an extensible set of
> flags that live in the ELF interpreter's headers somewhere that
> indicate compatibility hacks that the program in question doesn't
> need?  There are at least two things I can think of:
> 
>  - no_compat_vdso32: indicates an interpreter that can load a modern
> non-prelinked vdso
>  - no_vsyscall64: indicates that the libc will not attempt to call
> into the vsyscall page on x86_64.
> 
> I'm sure that there are more.  Think PT_GNU_STACK but for more than
> just the stack.
> 
> If we do something like this, there should probably be a prctl or
> similar that can change some of the flags at runtime, too.
> 

This comes many years too late for this purpose.  Such flags might have
a use, but at this point it is rather meaningless, I think.

	-hpa

