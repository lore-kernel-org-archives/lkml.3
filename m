Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3LSP1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:27:07 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42888 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3LSP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:27:05 -0500
Date: Thu, 19 Dec 2013 10:27:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] closures: move to lib/
Message-ID: <20131219152701.GC16994@htj.dyndns.org>
References: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
 <20131219120516.GA26089@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219120516.GA26089@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 19, 2013 at 04:05:16AM -0800, Christoph Hellwig wrote:
> On Wed, Dec 18, 2013 at 05:29:54PM -0800, Kent Overstreet wrote:
> > the closure code was never intended to be bcache specific - hopefully it can be
> > useful elsewhere in the kernel.
> 
> They are not.  They aren't closures in the CS sense, and they are an
> ugly mess.  Please work on removing them instead.

I pretty much agree with Christoph here.  Compared to all other
generic utilities we have, the proposed mechanism is giant in its
conceptual complexity.  This is a lot worse than semaphores.  I
personally think inclusion of it in the upstream kernel at all was a
bad idea.

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
