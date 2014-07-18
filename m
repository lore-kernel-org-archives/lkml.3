Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbaGRX3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:29:35 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39897 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaGRX3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:29:31 -0400
Date: Fri, 18 Jul 2014 19:29:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 10/31] watchdog: Replace __raw_get_cpu_var uses
Message-ID: <20140718232927.GQ5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193126.037585841@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193126.037585841@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:25PM -0500, Christoph Lameter wrote:
> Most of these are the uses of &__raw_get_cpu_var for address calculation.
> 
> touch_softlockup_watchdog_sync() uses __raw_get_cpu_var to write to
> per cpu variables. Use __this_cpu_write instead.
> 
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
