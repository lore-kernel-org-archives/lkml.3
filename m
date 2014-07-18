Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbaGRX3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:29:23 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:42787 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaGRX3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:29:20 -0400
Date: Fri, 18 Jul 2014 19:29:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 09/31] drivers/net/ethernet/tile: Replace __get_cpu_var
 uses for address calculation
Message-ID: <20140718232916.GP5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193125.907252541@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193125.907252541@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:24PM -0500, Christoph Lameter wrote:
> Replace with this_cpu_ptr.
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
