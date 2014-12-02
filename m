Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaLBRLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:11:16 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:50918 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbaLBRLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:11:14 -0500
Date: Tue, 2 Dec 2014 12:11:02 -0500
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Final per cpu consistency patch for -next or late in 3.19 merge
 period
Message-ID: <20141202171102.GC10918@htj.dyndns.org>
References: <alpine.DEB.2.11.1411281229350.11435@gentwo.org>
 <20141202164024.GA10918@htj.dyndns.org>
 <alpine.DEB.2.11.1412021049580.13039@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412021049580.13039@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:57:50AM -0600, Christoph Lameter wrote:
> On Tue, 2 Dec 2014, Tejun Heo wrote:
> 
> > Can you please update Documentation/local_ops.txt and comments which
> > contain __get_cpu_var() and send the updated patch to Andrew?
> 
> Owww.... local_* ops are exotic operations that should no longer be
> regularly used. This_cpu ops create less overhead and
> are simpler to use. Lets merge the prior patch as is and then add this
> documentation patch which may cause some additional discussion.

Sure, I just wanna make sure we don't have dangling references to
__get_cpu_var() which no longer exists.  There are also a couple
places where comment text refers to it.  Let's please take care of
them too.

Thanks.

-- 
tejun
