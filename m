Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbaGOCLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 22:11:10 -0400
Received: from ozlabs.org ([103.22.144.67]:36450 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaGOCLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 22:11:06 -0400
Message-ID: <1405390262.17767.5.camel@concordia>
Subject: Re: [PATCH v5 2/2] [BUGFIX] kprobes: Fix "Failed to find blacklist"
 error on ia64 and ppc64
From: Michael Ellerman <mpe@ellerman.id.au>
To: Tony Luck <tony.luck@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, linux-tip-commits@vger.kernel.org,
        akataria@vmware.com, anil.s.keshavamurthy@intel.com,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, yrl.pp-manager.tt@hitachi.com,
        Thomas Gleixner <tglx@linutronix.de>, Kevin Hao <haokexin@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 15 Jul 2014 12:11:02 +1000
In-Reply-To: <CA+8MBbJH3EfiGctxLpXScGEtvBNXkNVYEnyahihnCie1FgO+9Q@mail.gmail.com>
References: <1404276081.7254.1.camel@concordia>
	 <20140702070029.14689.18485.stgit@kbuild-fedora.novalocal>
	 <53BBDEE6.1080800@hitachi.com>
	 <CA+8MBbJH3EfiGctxLpXScGEtvBNXkNVYEnyahihnCie1FgO+9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 10:17 -0700, Tony Luck wrote:
> On Tue, Jul 8, 2014 at 5:07 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
> > Ping?
> >
> > This patch can be applied without 1/2, and will fix ia64/ppc64 problem.
> 
> Is somebody going to push this upstream? Another week has gone by,
> we are at -rc5, and I'm still seeing the
> 
>   Failed to find blacklist a00000010133b150
> 
> messages on ia64.

I don't see those messages on ppc64, I don't know where the original report
that it was broken on ppc64 came from. So I'm a bit lukewarm on the patch.

cheers


