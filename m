Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbbAUDz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:55:29 -0500
Received: from ozlabs.org ([103.22.144.67]:57398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbbAUDz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:55:28 -0500
Date: Wed, 21 Jan 2015 14:55:25 +1100
From: Anton Blanchard <anton@samba.org>
To: Jason Baron <jbaron@akamai.com>
Cc: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "mmarek@suse.cz" <mmarek@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] powerpc: Include linux/jump_label.h to get
 HAVE_JUMP_LABEL define
Message-ID: <20150121145525.49c9510b@kryten>
In-Reply-To: <54AD4C1C.60505@akamai.com>
References: <1420626958-31254-1-git-send-email-anton@samba.org>
	<1420626958-31254-3-git-send-email-anton@samba.org>
	<54AD4C1C.60505@akamai.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

> > diff --git a/arch/powerpc/platforms/pseries/lpar.c
> > b/arch/powerpc/platforms/pseries/lpar.c index 469751d..14ac1ad
> > 100644 --- a/arch/powerpc/platforms/pseries/lpar.c
> > +++ b/arch/powerpc/platforms/pseries/lpar.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/console.h>
> >  #include <linux/export.h>
> >  #include <linux/static_key.h>
> > +#include <linux/jump_label.h>
> >  #include <asm/processor.h>
> >  #include <asm/mmu.h>
> >  #include <asm/page.h>
> 
> You can drop the 'static_key.h' include here since its redundant.

Thanks, I incorporated this into the next series.

Anton
