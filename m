Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaLIViE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:38:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaLIViB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:38:01 -0500
Date: Tue, 09 Dec 2014 16:37:58 -0500 (EST)
Message-Id: <20141209.163758.1934464464299516168.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: the next chunk of iov_iter-net stuff for review
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141209212337.GK22149@ZenIV.linux.org.uk>
References: <20141209210414.GJ22149@ZenIV.linux.org.uk>
	<20141209.161712.1258837733606317716.davem@davemloft.net>
	<20141209212337.GK22149@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 13:38:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 9 Dec 2014 21:23:37 +0000

> On Tue, Dec 09, 2014 at 04:17:12PM -0500, David Miller wrote:
>> From: Al Viro <viro@ZenIV.linux.org.uk>
>> Date: Tue, 9 Dec 2014 21:04:14 +0000
>> 
>> > Well, I've got no comments whatsoever on the networking side of things;
>> 
>> I've been away for more than 10 days, so I personally haven't had time
>> to review any of it.
>> 
>> Why don't you respin and I'll try to allocate some review time myself?
> 
> Umm...  Do you want a rebase on top of current net-next/master?

Sure, why not?
