Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3C2LYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:24:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:44997 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3C2LYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:24:30 -0400
Date: Fri, 29 Mar 2013 12:24:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [patch 31/34] tile: Use generic idle loop
In-Reply-To: <515464B0.8080704@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1303291224130.22263@ionos>
References: <20130321214930.752934102@linutronix.de> <20130321215235.348460344@linutronix.de> <515464B0.8080704@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Srivatsa S. Bhat wrote:
> 
> That doesn't look quite right, since it returns -1 (instead of 0) when
> str == poll.

Stupid me.
