Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaCFWis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:38:48 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34240 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCFWir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:38:47 -0500
Date: Thu, 06 Mar 2014 17:38:45 -0500 (EST)
Message-Id: <20140306.173845.733270648823204984.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, tim@electronghost.co.uk,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] AF_RXRPC fixes and development [ver #2]
From: David Miller <davem@davemloft.net>
In-Reply-To: <8493.1394145149@warthog.procyon.org.uk>
References: <20140306124614.16645.50744.stgit@warthog.procyon.org.uk>
	<8007.1394144113@warthog.procyon.org.uk>
	<8493.1394145149@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 14:38:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 06 Mar 2014 22:32:29 +0000

> David Miller <davem@davemloft.net> wrote:
> 
>> If you do, submit just the bug fixes against 'net'
> 
> One more question:  When you say "against 'net'", do you mean a particular
> branch of a git tree?  If so, disregard the pull request I just sent you and
> I'll rebase.

I do not use branches.

I instead have just two trees, 'net' and 'net-next'
