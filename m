Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaLIUXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:23:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38342 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaLIUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:23:28 -0500
Date: Tue, 09 Dec 2014 15:23:25 -0500 (EST)
Message-Id: <20141209.152325.555830295797189797.davem@davemloft.net>
To: guz.fnst@cn.fujitsu.com
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] net: introduce helper macra CMSG_FOREACH_HDR
From: David Miller <davem@davemloft.net>
In-Reply-To: <54816CD3.90107@cn.fujitsu.com>
References: <54815B40.1050909@cn.fujitsu.com>
	<1417766552.2721.45.camel@perches.com>
	<54816CD3.90107@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 12:23:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Fri, 5 Dec 2014 16:29:07 +0800

> Hi Joe,
> Thanks for your comment.
> On 12/05/2014 04:02 PM, Joe Perches wrote:
> 
>> On Fri, 2014-12-05 at 15:14 +0800, Gu Zheng wrote:
>>> Introduce helper macra
>> 
>> macro
> 
> Ah~, it's a typo.
> 
>> 
>>> CMSG_FOREACH_HDR as a wrapper of the enumerating
>>> cmsghdr from msghdr, just cleanup. 
>> 
>> maybe better to use lower case "for_each_cmsg_hdr"
>> or some such.
> 
> But this will make it out of the ordinary, as the existed ones
> are all upper.
> 
> David, what's your opinion?

I think lowercase looks much better.
