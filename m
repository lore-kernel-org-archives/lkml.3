Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbaGRX3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:29:49 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60346 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaGRX3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:29:46 -0400
Date: Fri, 18 Jul 2014 19:29:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 11/31] net: Replace get_cpu_var through this_cpu_ptr
Message-ID: <20140718232942.GR5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193126.160285131@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193126.160285131@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:26PM -0500, Christoph Lameter wrote:
> Replace uses of get_cpu_var for address calculation through this_cpu_ptr.
> 
> Cc: netdev@vger.kernel.org
> Cc: Eric Dumazet <edumazet@google.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
