Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbaDIP2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:28:31 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49267 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbaDIP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:28:30 -0400
Date: Wed, 9 Apr 2014 17:28:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@fb.com>,
        Kevin Hilman <khilman@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL v2] nohz: Move nohz kick out of scheduler IPI
Message-ID: <20140409152822.GB17782@localhost.localdomain>
References: <1396541832-459-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396541832-459-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 06:17:10PM +0200, Frederic Weisbecker wrote:
> Ingo, Thomas,
> 
> Please pull the timers/nohz-ipi-for-tip-v3 branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz-ipi-for-tip-v3

Ping?
