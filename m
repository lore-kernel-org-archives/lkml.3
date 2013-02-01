Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3BANxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:53:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:34165 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3BANxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:53:00 -0500
Date: Fri, 1 Feb 2013 14:52:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hillf Danton <dhillf@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul@jasper.es
Subject: Re: [patch 09/40] cpu: hotplug: Implement setup/removal interface
In-Reply-To: <CAJd=RBCn0bM2rkXD3C6+7UZxFGO=fT7JNAcG-3SjR_zuGOZiCw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302011452340.11905@ionos>
References: <20130131120348.372374706@linutronix.de> <20130131120742.098044736@linutronix.de> <CAJd=RBCn0bM2rkXD3C6+7UZxFGO=fT7JNAcG-3SjR_zuGOZiCw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, Hillf Danton wrote:
> On Thu, Jan 31, 2013 at 8:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > +/**
> > +       for_each_present_cpu(cpu) {
> > +               int ret, cpustate = per_cpu(cpuhp_state, cpu);
> 
> s/ret,//

Duh, yes.
