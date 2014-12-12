Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbaLLCQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:16:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58792 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaLLCQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:16:07 -0500
Date: Thu, 11 Dec 2014 21:16:02 -0500 (EST)
Message-Id: <20141211.211602.1228496215945360802.davem@davemloft.net>
To: alexander.h.duyck@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com, mingo@kernel.org,
        linux-arch@vger.kernel.org, mikey@neuling.org, linux@arm.linux.org.uk,
        donald.c.skidmore@intel.com, matthew.vick@intel.com,
        geert@linux-m68k.org, jeffrey.t.kirsher@intel.com,
        romieu@fr.zoreil.com, paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com,
        arnd@arndb.de, will.deacon@arm.com, michael@ellerman.id.au,
        tony.luck@intel.com, torvalds@linux-foundation.org, oleg@redhat.com,
        schwidefsky@de.ibm.com, fweisbec@gmail.com
Subject: Re: [net-next PATCH v7 resubmit 0/4] arch: Add lightweight memory
 barriers for coherent memory access
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141211225250.25464.30291.stgit@ahduyck-server>
References: <20141125203310.8240.27370.stgit@ahduyck-server>
	<20141211225250.25464.30291.stgit@ahduyck-server>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 18:16:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@redhat.com>
Date: Thu, 11 Dec 2014 15:01:43 -0800

> These patches introduce two new primitives for synchronizing cache coherent
> memory writes and reads.

Series applied, thanks Alex.
