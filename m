Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaFDSMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:12:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:42117 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197AbaFDSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:12:28 -0400
Date: Wed, 4 Jun 2014 14:12:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Brad Mouring <bmouring@ni.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140604141225.1c26ae96@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1406041951210.3319@nanos>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
	<1400855410-14773-2-git-send-email-brad.mouring@ni.com>
	<20140603210609.62de6451@gandalf.local.home>
	<alpine.DEB.2.10.1406041623170.3319@nanos>
	<20140604114411.0fe51c1d@gandalf.local.home>
	<alpine.DEB.2.10.1406041951210.3319@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 20:02:16 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

 
> My brain still suffers from 3 days staring into futex.c

Hopefully that's not permanent damage.

> 
> I'll fixup the check so it wont break the real deadlock case and queue
> it.
> 

Cool. Could you include my write up on the locking scenario in the
change log so that it is documented somewhere other than mail archives.

Thanks,

-- Steve
