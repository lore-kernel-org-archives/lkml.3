Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaA3JTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:19:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:52443 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaA3JTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:19:32 -0500
Message-ID: <1391073314.8524.115.camel@pasglop>
Subject: Re: [PATCH] kconfig: consolidate arch-specific seccomp options
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, sfr@canb.auug.org.au,
        zohar@linux.vnet.ibm.com, linux@arm.linux.org.uk, monstr@monstr.eu,
        ralf@linux-mips.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, lethal@linux-sh.org, x86@kernel.org,
        james.l.morris@oracle.com
Date: Thu, 30 Jan 2014 20:15:14 +1100
In-Reply-To: <20140130085551.GB2024@gmail.com>
References: <20140129191011.8FB63DFA@viggo.jf.intel.com>
	 <20140130085551.GB2024@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 09:55 +0100, Ingo Molnar wrote:
> * Dave Hansen <dave@sr71.net> wrote:

> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > There are 7 architecures with "config SECCOMP".  They all have
> > virtually the same help text except for those referencing the
> > /proc interface.  The /proc interface was removed in 2007.
> > 
> > There is *NOTHING* architecture-specific about SECCOMP except
> > that the syscalls have per-architecture definitions, like every
> > other syscall.  It is absurd to have the option in the
> > arch-specific menus.
> > 
> > Move it to the security menu, consolidate the 7 down to one, and
> > remove the embarassingly-ancient help text references and
> > dependencies on /proc.
> > 
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: linux-security-module@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Michal Simek <monstr@monstr.eu>
> > Cc: Ralf Baechle <ralf@linux-mips.org> 

For powerpc:

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


