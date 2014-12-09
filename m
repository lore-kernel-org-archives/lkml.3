Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaLIXNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:13:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37567 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbaLIXNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:13:12 -0500
Date: Tue, 9 Dec 2014 23:13:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: the next chunk of iov_iter-net stuff for review
Message-ID: <20141209231310.GM22149@ZenIV.linux.org.uk>
References: <20141209224928.GL22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209224928.GL22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 10:49:28PM +0000, Al Viro wrote:

> OK, rebase is in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-davem-2,
> individual patches - in followups (first 13 - iov_iter, then 12 net-related)

PS: the pile next after that one is also there, in 
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git iov_iter-net-2
but that one contains several things I'd *really* like to hear comments
about (asked about all of them on netdev, no reply so far).  Let's sort this
one out first...

Al, diving back into VFS-related queues...
