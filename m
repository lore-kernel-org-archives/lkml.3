Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaFDUuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:50:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:41208 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFDUt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:49:58 -0400
Date: Wed, 4 Jun 2014 22:49:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Brad Mouring <bmouring@ni.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
In-Reply-To: <20140604141225.1c26ae96@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406042249250.18296@nanos>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com> <1400855410-14773-2-git-send-email-brad.mouring@ni.com> <20140603210609.62de6451@gandalf.local.home> <alpine.DEB.2.10.1406041623170.3319@nanos> <20140604114411.0fe51c1d@gandalf.local.home>
 <alpine.DEB.2.10.1406041951210.3319@nanos> <20140604141225.1c26ae96@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Steven Rostedt wrote:

> On Wed, 4 Jun 2014 20:02:16 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>  
> > My brain still suffers from 3 days staring into futex.c
> 
> Hopefully that's not permanent damage.

Staring into rtmutex.c does not make it any better ...
