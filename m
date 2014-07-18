Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694AbaGRXa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:30:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55248 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293AbaGRXax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:30:53 -0400
Date: Fri, 18 Jul 2014 19:30:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 17/31] uv: Replace __get_cpu_var
Message-ID: <20140718233050.GW5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193126.861853673@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193126.861853673@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:32PM -0500, Christoph Lameter wrote:
> Use __this_cpu_read instead.
> 
> Cc: Hedi Berriche <hedi@sgi.com>
> Cc: Mike Travis <travis@sgi.com>
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
