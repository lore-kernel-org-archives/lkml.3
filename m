Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaHZR7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:59:39 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:45486 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaHZR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:59:38 -0400
Date: Tue, 26 Aug 2014 13:59:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 01/41] mm: Replace __get_cpu_var uses with this_cpu_ptr
Message-ID: <20140826175933.GA31659@mtj.dyndns.org>
References: <20131203233232.928771708@linux.com>
 <20131203233245.411363890@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203233245.411363890@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:32:33PM -0600, Christoph Lameter wrote:
> Replace places where __get_cpu_var() is used for an address calculation
> with this_cpu_ptr().
> 
> Cc: akpm@linux-foundation.org
> Cc: linux-mm@kvack.org
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
