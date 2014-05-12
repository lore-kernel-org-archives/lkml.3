Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbaELRMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:12:41 -0400
Received: from 1wt.eu ([62.212.114.60]:34948 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbaELRMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:12:39 -0400
Date: Mon, 12 May 2014 19:12:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jon Maloy <jon.maloy@ericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ying Xue <ying.xue@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 072/143] tipc: fix lockdep warning during bearer initialization
Message-ID: <20140512171234.GA21366@1wt.eu>
References: <20140512003203.627061916@1wt.eu> <5370F0F0.1020606@ericsson.com> <20140512161613.GD19173@1wt.eu> <A2BAEFC30C8FD34388F02C9B3121859D1C250675@eusaamb103.ericsson.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2BAEFC30C8FD34388F02C9B3121859D1C250675@eusaamb103.ericsson.se>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 04:41:00PM +0000, Jon Maloy wrote:
> Sorry, I should have mentioned that it is still only in net-next.
> It is pretty recent.

OK indeed, got it here for reference :

  https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=7216cd949c9bd56

But anyway, what is mentionned in this commit is a number of changes that
happened between 2.6.32 and 3.15, so I hardly see how the tipc_net_lock
is obsolete in 2.6.32 if it does not have all these changes. I have counted
489 commits between 2.6.32 and 3.15-rc5 touching net/tipc, so surely we
cannot count on what we have to get rid of this lock.

Am I missing anything ?

Thanks,
Willy

