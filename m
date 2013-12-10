Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3LJPew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:34:52 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:55084 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3LJPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:34:49 -0500
Date: Tue, 10 Dec 2013 10:34:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
Message-ID: <20131210153445.GE4610@htj.dyndns.org>
References: <20131203233232.928771708@linux.com>
 <20131203233251.745099192@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203233251.745099192@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:32:45PM -0600, Christoph Lameter wrote:
> The patches following this one will add preemption checks to __this_cpu
> ops so we need to have an alternative way to use this_cpu operations
> without preemption checks.
> 
> raw_cpu_ops will be the basis for all other ops since these will be the
> operations that do not implement any checks. 
> 
> Primitive operations are renamed by this patch from __this_cpu_xxx to
> raw_cpu_xxxx.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.14.

Thanks.

-- 
tejun
