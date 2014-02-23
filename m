Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaBWW1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:27:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:45363 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaBWW1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:27:44 -0500
Message-ID: <1393194410.6771.153.camel@pasglop>
Subject: Re: [patch 03/26] powerpc: eeh: Kill another abuse of irq_desc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        ppc <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 24 Feb 2014 09:26:50 +1100
In-Reply-To: <20140223212736.562906212@linutronix.de>
References: <20140223212703.511977310@linutronix.de>
	 <20140223212736.562906212@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3-0ubuntu3~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problems iirc have to do with drivers doing stupid things, but I'll
let Gavin comment further and fix that up properly.

Cheers,
Ben.


