Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaA1UPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:15:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39486 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbaA1UPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:15:47 -0500
Date: Tue, 28 Jan 2014 21:15:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140128201536.GB5178@pd.tnic>
References: <20140128062806.GA20750@gmail.com>
 <52E76997.40303@nod.at>
 <52E7D2E5.8090208@linux.intel.com>
 <52E7D9FF.1080506@nod.at>
 <52E7DB15.3090808@zytor.com>
 <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
 <20140128170507.GA16279@gmail.com>
 <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
 <20140128194823.GA18702@gmail.com>
 <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:07:26PM -0800, Linus Torvalds wrote:
> On Tue, Jan 28, 2014 at 11:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > I really meant it when I said I build without debuginfo! :)
> 
> Ok, but so what?
> 
> As mentioned, nobody sane should build with DEBUG_INFO.

Shouldn't we hold that down in the Kconfig help text of DEBUG_INFO?
Something like:

"You don't need to enable this if you want symbolic names for kernel
objects. Enable CONFIG_KALLSYMS instead."

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
