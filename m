Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbaLKUcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:32:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56400 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481AbaLKUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:32:15 -0500
Date: Thu, 11 Dec 2014 15:32:04 -0500 (EST)
Message-Id: <20141211.153204.228153607927530694.davem@davemloft.net>
To: alexander.duyck@gmail.com
Cc: alexander.h.duyck@redhat.com, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com, mingo@kernel.org,
        mikey@neuling.org, linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, will.deacon@arm.com,
        michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com
Subject: Re: [PATCH v7 0/4] arch: Add lightweight memory barriers for
 coherent memory access
From: David Miller <davem@davemloft.net>
In-Reply-To: <54892B87.3020909@gmail.com>
References: <20141125203310.8240.27370.stgit@ahduyck-server>
	<54892B87.3020909@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 12:32:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Wed, 10 Dec 2014 21:28:39 -0800

> It occurs to me that I never got a sign off from any of the maintainers
> on getting this pulled in.
> 
> Since the merge window is open I was wondering which tree I should make
> sure these patches apply to and who will be the one to pull them in?
> Since I was modifying network drivers should I resubmit them for netdev,
> or should I submit them for asm-generic or some other tree?

I have no problem taking this via my tree, but I want to see agreement
from other interested parties.
