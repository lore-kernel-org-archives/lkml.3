Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaLIUHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:07:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38218 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaLIUHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:07:36 -0500
Date: Tue, 09 Dec 2014 15:07:32 -0500 (EST)
Message-Id: <20141209.150732.158834258918114526.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: the next chunk of iov_iter-net stuff for review
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141205055623.GQ29748@ZenIV.linux.org.uk>
References: <20141125205911.GA29748@ZenIV.linux.org.uk>
	<20141126.122727.1791815907895724977.davem@davemloft.net>
	<20141205055623.GQ29748@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 12:07:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 5 Dec 2014 05:56:23 +0000

> 	OK, here's the tentative next batch (covers most of the ->recvmsg()
> side of conversion).  That's on top of merge of net-next#master with
> vfs#iov_iter (the latter had been posted earlier today, Cc'd to netdev among
> other places).  This series corresponds to vfs#for-davem.  Review and comments
> would be very welcome...

Al, what's the state of this?  The iov_iter rewrite had some changes
recently.

Also, never assume I just know what GIT url to pull from, always
explicitly state where you want me to pull changes from.

Thanks.
