Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3LPQYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:24:48 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:51204 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3LPQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:24:41 -0500
Date: Mon, 16 Dec 2013 17:23:47 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH 10/10] Kconfig: cleanup SERIO_I8042 dependencies
Message-ID: <20131216162346.GA19285@linux-mips.org>
References: <1387040376-26906-1-git-send-email-msalter@redhat.com>
 <1387040376-26906-11-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387040376-26906-11-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 11:59:36AM -0500, Mark Salter wrote:

> -	depends on !PARISC && (!ARM || FOOTBRIDGE_HOST) && \
> -		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390 && \
> -		   !ARC
> +	depends on ARCH_MIGHT_HAVE_PC_SERIO

Most dependencies on an architecture's kconfig symbol outside arch/
should probably be treated as a bug.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
