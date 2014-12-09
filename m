Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaLIVXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:23:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37211 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaLIVXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:23:39 -0500
Date: Tue, 9 Dec 2014 21:23:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: the next chunk of iov_iter-net stuff for review
Message-ID: <20141209212337.GK22149@ZenIV.linux.org.uk>
References: <20141205055623.GQ29748@ZenIV.linux.org.uk>
 <20141209.150732.158834258918114526.davem@davemloft.net>
 <20141209210414.GJ22149@ZenIV.linux.org.uk>
 <20141209.161712.1258837733606317716.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209.161712.1258837733606317716.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 04:17:12PM -0500, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Tue, 9 Dec 2014 21:04:14 +0000
> 
> > Well, I've got no comments whatsoever on the networking side of things;
> 
> I've been away for more than 10 days, so I personally haven't had time
> to review any of it.
> 
> Why don't you respin and I'll try to allocate some review time myself?

Umm...  Do you want a rebase on top of current net-next/master?
