Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaA2WxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 17:53:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:48174 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaA2WxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 17:53:23 -0500
Message-ID: <1391035987.8524.79.camel@pasglop>
Subject: Re: compile error on linus git with ppc64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Rientjes <rientjes@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 30 Jan 2014 09:53:07 +1100
In-Reply-To: <alpine.DEB.2.02.1401290059490.12210@chino.kir.corp.google.com>
References: <20140128194311.00004303@unknown>
	 <alpine.DEB.2.02.1401281953040.32278@chino.kir.corp.google.com>
	 <1390985190.8524.54.camel@pasglop>
	 <alpine.DEB.2.02.1401290059490.12210@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 01:00 -0800, David Rientjes wrote:
> On Wed, 29 Jan 2014, Benjamin Herrenschmidt wrote:
> 
> > I have a fix queued up in next, I'll ask Linus to pull tomorrow.
> > 
> 
> Which fix?  From linux-next-20140129:

I pushed it yesterday, it might not have made it to sfr yet. I'll send
it to Linus today.

http://git.kernel.org/cgit/linux/kernel/git/benh/powerpc.git/commit/?h=next&id=fd120dc2e205d2318a8b47d6d8098b789e3af67d

Cheers,
Ben.

> In file included from include/linux/spinlock.h:81:0,
>                  from include/linux/seqlock.h:35,
>                  from include/linux/time.h:5,
>                  from include/uapi/linux/timex.h:56,
>                  from include/linux/timex.h:56,
>                  from include/linux/sched.h:17,
>                  from arch/powerpc/kernel/asm-offsets.c:17:
> include/linux/spinlock_types.h:76:3: error: redefinition of typedef 'spinlock_t'
> arch/powerpc/include/asm/pgtable-ppc64.h:563:25: note: previous declaration of 'spinlock_t' was here


