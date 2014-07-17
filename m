Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbaGQLL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:11:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:56040 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712AbaGQLL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:11:56 -0400
Message-ID: <1405595380.25310.21.camel@pasglop>
Subject: Re: [PATCH V3 0/3] Add new PowerPC specific ELF core notes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, james.hogan@imgtec.com,
        avagin@openvz.org, Paul.Clothier@imgtec.com, davem@davemloft.net,
        peterz@infradead.org, palves@redhat.com, linux-kernel@vger.kernel.org,
        oleg@redhat.com, dhowells@redhat.com, linuxppc-dev@ozlabs.org,
        davej@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Date: Thu, 17 Jul 2014 21:09:40 +1000
In-Reply-To: <53C7A4FA.4030600@linux.vnet.ibm.com>
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
	 <53996E41.4070309@linux.vnet.ibm.com> <53C7A4FA.4030600@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >> Outstanding Issues
> >> ==================
> >> (1) Running DSCR register value inside a transaction does not seem to be saved
> >>     at thread.dscr when the process stops for ptrace examination.
> > 
> > Hey Ben,
> > 
> > Any updates on this patch series ?
> 
> Ben,
> 
> Any updates on this patch series ?

I haven't had a chance to review yet, I was hoping somebody else would..

Have you made any progress vs. the DSCR outstanding issue mentioned
above ?

Cheers,
Ben.


