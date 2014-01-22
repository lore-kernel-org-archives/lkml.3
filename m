Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaAVBdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:33:06 -0500
Received: from ozlabs.org ([203.10.76.45]:57075 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbaAVBdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:33:02 -0500
Message-ID: <1390354379.11104.3.camel@concordia>
Subject: Re: [PATCH 0/8] Add support for PowerPC Hypervisor supplied
 performance counters
From: Michael Ellerman <mpe@ellerman.id.au>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Wed, 22 Jan 2014 12:32:59 +1100
In-Reply-To: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 15:53 -0800, Cody P Schafer wrote:
> These patches add basic pmus for 2 powerpc hypervisor interfaces to obtain
> performance counters: gpci ("get performance counter info") and 24x7.
> 
> The counters supplied by these interfaces are continually counting and never
> need to be (and cannot be) disabled or enabled. They additionally do not
> generate any interrupts. This makes them in some regards similar to software
> counters, and as a result their implimentation shares some common code (which
> an initial patch exposes) with the sw counters.

Hi Cody,

Can you please add some more explanation of this series.

In particular why do we need two new PMUs, and how do they relate to each
other?

And can you add an example of how I'd actually use them using perf.

cheers


