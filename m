Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3LOKhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 05:37:09 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33158 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3LOKhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 05:37:04 -0500
Date: Sun, 15 Dec 2013 02:36:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH 10/10] Kconfig: cleanup SERIO_I8042 dependencies
Message-ID: <20131215103657.GB20197@core.coreip.homeip.net>
References: <1387040376-26906-1-git-send-email-msalter@redhat.com>
 <1387040376-26906-11-git-send-email-msalter@redhat.com>
 <52ACA43F.2040402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52ACA43F.2040402@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 10:32:31AM -0800, H. Peter Anvin wrote:
> On 12/14/2013 08:59 AM, Mark Salter wrote:
> > Remove messy dependencies from SERIO_I8042 by having it depend on one
> > Kconfig symbol (ARCH_MIGHT_HAVE_PC_SERIO) and having architectures
> > which need it select ARCH_MIGHT_HAVE_PC_SERIO in arch/*/Kconfig.
> > New architectures are unlikely to need SERIO_I8042, so this avoids
> > having an ever growing list of architectures to exclude.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > CC: Richard Henderson <rth@twiddle.net>
> > CC: linux-alpha@vger.kernel.org
> > CC: Russell King <linux@arm.linux.org.uk>
> > CC: linux-arm-kernel@lists.infradead.org
> > CC: Tony Luck <tony.luck@intel.com>
> > CC: Fenghua Yu <fenghua.yu@intel.com>
> > CC: linux-ia64@vger.kernel.org
> > CC: Ralf Baechle <ralf@linux-mips.org>
> > CC: linux-mips@linux-mips.org
> > CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > CC: Paul Mackerras <paulus@samba.org>
> > CC: linuxppc-dev@lists.ozlabs.org
> > CC: Paul Mundt <lethal@linux-sh.org>
> > CC: linux-sh@vger.kernel.org
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: sparclinux@vger.kernel.org
> > CC: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > CC: Ingo Molnar <mingo@redhat.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: "H. Peter Anvin" <hpa@zytor.com>
> > CC: x86@kernel.org
> 
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>

How are we going to merge this? In bulk through input tree or peacemeal
through all arches first?

-- 
Dmitry
