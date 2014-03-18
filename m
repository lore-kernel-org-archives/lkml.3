Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbaCRSVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:21:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:56322 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCRSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:21:51 -0400
Date: Tue, 18 Mar 2014 19:21:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Vince Weaver wrote:

> 
> The perf_fuzzer can quickly cause a machine to lockup with an hrtimer 
> related rb tree related oops.  I've had a hard time debugging this in any 
> useful manner, but I can trigger it on both core2 and haswell test systems 
> on 3.14-rc7.
> 
> This involves making a large number of perf_event events of all types and 
> then forking a lot.

Can you enable debugobjects please? The should give us an hint what
corrupts the rbtree.

Thanks,

	tglx

 
