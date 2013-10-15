Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3JOK5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:57:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56049 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab3JOK5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:57:48 -0400
Date: Tue, 15 Oct 2013 12:57:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Len Brown <len.brown@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20131015105736.GB8682@pd.tnic>
References: <20131012171553.GA17548@gmail.com>
 <CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
 <52599277.3090502@zytor.com>
 <20131012184920.GA19065@gmail.com>
 <20131015071508.GA25059@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131015071508.GA25059@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:15:08AM +0200, Ingo Molnar wrote:
> One problem we have is that we have sporadic end user reports only,
> with no systematic testing done by Dell on these systems apparently.
> Is there anyone at Dell who cares about these reboot problems that
> upstream kernels exhibit with VT-d enabled?

For that, you probably want to CC a couple of Dell people who touched
arch/x86/ :)

$ git log -p arch/x86/ | grep "dell\.com"

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
