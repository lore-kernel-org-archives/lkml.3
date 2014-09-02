Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaIBPyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:54:15 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:59218 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaIBPyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:54:12 -0400
Date: Tue, 2 Sep 2014 11:54:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 29
Message-ID: <20140902155403.GC17424@htj.dyndns.org>
References: <20140829150713.50d78c30@canb.auug.org.au>
 <20140901173521.GA8259@roeck-us.net>
 <alpine.DEB.2.11.1409011615210.22966@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409011615210.22966@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 04:15:52PM -0500, Christoph Lameter wrote:
> On Mon, 1 Sep 2014, Guenter Roeck wrote:
> 
> > arch/ia64/sn/kernel/setup.c: In function 'sn_cpu_init':
> > arch/ia64/sn/kernel/setup.c:632:13: error: lvalue required as left operand of assignment
> > make[1]: *** [arch/ia64/sn/kernel/setup.o] Error 1
> > make: *** [arch/ia64/sn/kernel/setup.o] Error 2
> 
> 
> Subject: ia64: sn_nodepda cannot be assigned to after this_cpu conversion. Use __this_cpu_write.
> 
> There must be an explit statement to modify the percpu variable after the conversion of the
> sn_nodpda macro to use this_cpu_read.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.18-consistent-ops.

Thanks.

-- 
tejun
