Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaGNRSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:18:01 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:43766 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaGNRRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:17:53 -0400
MIME-Version: 1.0
In-Reply-To: <53BBDEE6.1080800@hitachi.com>
References: <1404276081.7254.1.camel@concordia>
	<20140702070029.14689.18485.stgit@kbuild-fedora.novalocal>
	<53BBDEE6.1080800@hitachi.com>
Date: Mon, 14 Jul 2014 10:17:52 -0700
Message-ID: <CA+8MBbJH3EfiGctxLpXScGEtvBNXkNVYEnyahihnCie1FgO+9Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] [BUGFIX] kprobes: Fix "Failed to find blacklist"
 error on ia64 and ppc64
From: Tony Luck <tony.luck@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        sparse@chrisli.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, linux-tip-commits@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, akataria@vmware.com,
        anil.s.keshavamurthy@intel.com,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 5:07 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> Ping?
>
> This patch can be applied without 1/2, and will fix ia64/ppc64 problem.

Is somebody going to push this upstream? Another week has gone by,
we are at -rc5, and I'm still seeing the

  Failed to find blacklist a00000010133b150

messages on ia64.

-Tony
