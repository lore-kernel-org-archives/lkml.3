Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaA2Kk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:40:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35124 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaA2Kk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:40:57 -0500
Date: Wed, 29 Jan 2014 11:40:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140129104046.GB24887@pd.tnic>
References: <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
 <20140128170507.GA16279@gmail.com>
 <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
 <20140128194823.GA18702@gmail.com>
 <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
 <20140128201536.GB5178@pd.tnic>
 <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
 <52E812F4.50906@nod.at>
 <52E8153A.2000208@zytor.com>
 <20140129082505.GB31489@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140129082505.GB31489@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 09:25:05AM +0100, Ingo Molnar wrote:
> That would default to Y and would disable debuginfo by default.
>
> ( And yeah, it's a bit ugly, but it beats having to hack the kconfig
> language! )

Yeah, that could be another solution - I came up with another hack last
night: http://marc.info/?l=linux-kernel&m=139095226124549

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
