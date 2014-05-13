Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbaEMHbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:31:48 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:37531 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbaEMHbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:31:46 -0400
Message-ID: <1399966293.4137.5.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] compiler.h: don't use temporary variable in
 __compiletime_assert()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Date: Tue, 13 May 2014 09:31:33 +0200
In-Reply-To: <20140512141642.5eb526deed5ea32ad5bced72@linux-foundation.org>
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
	 <5370CFAC.40705@imgtec.com>
	 <20140512141642.5eb526deed5ea32ad5bced72@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 14:16 -0700, Andrew Morton wrote:

> > I don't understand why your patch should break things, I suspect it's
> > related to the sparse behaviour you're trying to work around, but can we
> > please drop this patch until a more portable workaround can be found?
> 
> Older gcc's often have this problem.
> 
> I suppose that build bustage is more serious than sparse false
> positives so yes, let's please try to find an alternative.

Since most people probably don't use sparse without compiling (in fact
it's pretty difficult to do so) I'll just send a patch to disable
__compiletime_assert for sparse - any objections?

johannes

