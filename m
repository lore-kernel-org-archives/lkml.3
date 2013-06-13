Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab3FMXNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:13:51 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:53414 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3FMXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:13:49 -0400
Date: Thu, 13 Jun 2013 16:13:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613231342.GH13970@mtj.dyndns.org>
References: <20130613020536.GA10979@localhost>
 <20130612200311.7f9d938a.akpm@linux-foundation.org>
 <20130613185318.GB12075@mtj.dyndns.org>
 <20130613120439.fe56d178a1143089136fdacc@linux-foundation.org>
 <20130613191507.GB13970@mtj.dyndns.org>
 <20130613122339.239a721d097a64435817a780@linux-foundation.org>
 <20130613193514.GD13970@mtj.dyndns.org>
 <20130613151040.8e11da022519fff7d5e8ea77@linux-foundation.org>
 <20130613223028.GG13970@mtj.dyndns.org>
 <20130613153551.39ffdf595d989be10c773d23@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613153551.39ffdf595d989be10c773d23@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 13, 2013 at 03:35:51PM -0700, Andrew Morton wrote:
> Well that's news.  My awe at the dreadfulness of Kent's changelog
> continues to grow.  Please identify these duplicated allocators
> (function names will suffice).  That way, others can actually review
> this code :(

Oh yeah, Kent could and should have sold it much better.  :)

Thanks.

-- 
tejun
