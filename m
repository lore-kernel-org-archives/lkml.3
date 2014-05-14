Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaENXPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:15:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:48810 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaENXPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:15:14 -0400
Date: Thu, 15 May 2014 01:15:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V5
In-Reply-To: <alpine.DEB.2.10.1405141105370.16512@gentwo.org>
Message-ID: <alpine.DEB.2.02.1405150111480.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1405121317270.29911@gentwo.org> <alpine.DEB.2.02.1405131651120.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405141105370.16512@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Christoph Lameter wrote:
> - Shepherd thread as a general worker thread. This means
>   that the general mechanism to control worker thread
>   cpu proposed by Frederic Weisbecker is necessary to
>   restrict the shepherd thread to the cpus not used
>   for low latency tasks. Hopefully that is ready to be
>   merged soon. No need anymore to have a specific
>   cpu be the housekeeper cpu.

Amen to that.

Acked-by me for the general approach.

I don't want to give any unqualified opinion on the mm/vmstat parts of
this patch.

Thanks,

	tglx


