Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaCGVMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:12:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43480 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaCGVMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:12:14 -0500
Date: Fri, 07 Mar 2014 16:12:12 -0500 (EST)
Message-Id: <20140307.161212.1983420659218947071.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, tim@electronghost.co.uk,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] AF_RXRPC fixes and development [ver #2]
From: David Miller <davem@davemloft.net>
In-Reply-To: <8473.1394145078@warthog.procyon.org.uk>
References: <20140306124614.16645.50744.stgit@warthog.procyon.org.uk>
	<8007.1394144113@warthog.procyon.org.uk>
	<8473.1394145078@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 13:12:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 06 Mar 2014 22:31:18 +0000

> David Miller <davem@davemloft.net> wrote:
> 
>> It depends upon whether you want the bug fixes to go into Linus's
>> tree for the current release or not.
> 
> The fixes aren't particularly urgent, so if net-next is aimed at the next
> merge window, I would be okay with you putting the whole pile in there at this
> point.
> 
> Below is a pull request on that basis.

Works for me, pulled, thanks David.
