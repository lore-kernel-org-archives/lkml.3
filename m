Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab3IKWCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 18:02:34 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:42830 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3IKWCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 18:02:33 -0400
Date: Thu, 12 Sep 2013 00:02:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130911220228.GB15367@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 08:07:37PM +0000, Christoph Lameter wrote:
> I am not sure how to call this kernel option but we need something like
> that. I see drivers and the kernel spawning processes on the nohz cores.
> The name kthread is not really catching the purpose.
> 
> os_cpus=? highlatency_cpus=?
> 
> 
> Subject: Restrict kernel spawning of threads to a specified set of cpus.
> 
> Currently the kernel by default allows kernel threads to be spawned on
> any cpu. This is a problem for low latency applications that want to
> avoid Os actions on specific processors.
> 
> Add a kernel option that restrict kthread and usermode spawning
> to a specific set of processors. Also sets the affinities of
> init by default to the restricted set since we certainly do not
> want userspace daemons etc to be started there either.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Why not do this from userspace instead?

Thanks.
