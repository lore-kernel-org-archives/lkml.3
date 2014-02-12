Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaBLCxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:53:32 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35071 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaBLCx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:53:29 -0500
Date: Tue, 11 Feb 2014 18:53:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Andrey Panin <pazke@donpac.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Dobson <colpatch@us.ibm.com>,
        Natalie Protasevich <protasnb@gmail.com>,
        Garry Forsgren <garry.forsgren@unisys.com>
Subject: [GIT PULL] x86, apic: Remove support for Summit and ES7000
In-Reply-To: <52F40F21.8070200@zytor.com>
Message-ID: <alpine.DEB.2.02.1402111841590.26393@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com> <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com> <52F40F21.8070200@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter, and Thomas,

 [ Be aware of bouncing emails on the cc, it includes the last-known email
   addresses of the authors of these subarchitectures and may bounce. ]

If you agree, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git x86/apic

  # HEAD: 7cf6c94591bbf3dbe3bf9573a6551328ad76d885 x86, apic: Remove support for IBM Summit/EXA chipset

or apply individually.  This branch is based on x86/apic.

This is the removal of Summit and ES7000 subarchitectures from x86.  I'd 
like to do the same for NumaQ, but am still researching if we can really 
do away with it.
---
 arch/x86/kernel/apic/es7000_32.c |  738 ---------------------------------------
 arch/x86/kernel/apic/summit_32.c |  550 -----------------------------
 arch/x86/Kconfig                 |   45 --
 arch/x86/kernel/acpi/boot.c      |   12 
 arch/x86/kernel/apic/Makefile    |    2 
 drivers/clocksource/Makefile     |    1 
 drivers/clocksource/cyclone.c    |  113 -----
 7 files changed, 9 insertions(+), 1452 deletions(-)
