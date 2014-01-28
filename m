Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaA1VKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:10:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315AbaA1VJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:09:58 -0500
Date: Tue, 28 Jan 2014 16:08:57 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140128210857.GA1377@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mathias Krause <minipli@googlemail.com>,
	Michael Davidson <md@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>
References: <52E7D2E5.8090208@linux.intel.com>
 <52E7D9FF.1080506@nod.at>
 <52E7DB15.3090808@zytor.com>
 <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
 <20140128170507.GA16279@gmail.com>
 <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
 <20140128194823.GA18702@gmail.com>
 <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
 <20140128201536.GB5178@pd.tnic>
 <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:25:15PM -0800, Linus Torvalds wrote:
 > On Tue, Jan 28, 2014 at 12:15 PM, Borislav Petkov <bp@alien8.de> wrote:
 > >
 > > Shouldn't we hold that down in the Kconfig help text of DEBUG_INFO?
 > > Something like:
 > >
 > > "You don't need to enable this if you want symbolic names for kernel
 > > objects. Enable CONFIG_KALLSYMS instead."
 > 
 > Probably. And then we should make sure that allyesconfig/allmodconfig
 > don't pick it.
 > 
 > There *are* reasonable uses for DEBUG_INFO:
 > 
 >  - if you very actively and extensively use kgdb, DEBUG_INFO is very useful.
 > 
 >  - distros might want to build distro kernels with DEBUG_INFO for the
 > kernel debug package

- objdump -S is kind of useful. I find myself using that quite often.
  (like at least a dozen times each merge window)

pretty sure it works with DEBUG_INFO_REDUCED though, which is somewhat
faster than full DEBUG_INFO

	Dave

