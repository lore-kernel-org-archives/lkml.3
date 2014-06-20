Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaFTObA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:31:00 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:38963
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbaFTOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:30:58 -0400
Date: Fri, 20 Jun 2014 09:30:52 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
In-Reply-To: <20140619220449.GT4904@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406200930270.10271@gentwo.org>
References: <53A2F406.4010109@oracle.com> <alpine.DEB.2.11.1406191001090.2785@gentwo.org> <20140619165247.GA4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192127100.5170@nanos> <20140619202928.GG4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192230390.5170@nanos>
 <20140619205307.GL4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192331250.5170@nanos> <20140619220449.GT4904@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Paul E. McKenney wrote:

> This commit therefore exports the debug_init_rcu_head() and
> debug_rcu_head_free() functions, which permits the allocators to allocated
> and pre-initialize the debug-objects information, so that there no longer
> any need for call_rcu() to do that initialization, which in turn prevents
> the recursion into the memory allocators.

Looks-good-to: Christoph Lameter <cl@linux.com>
