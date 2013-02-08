Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945893Ab3BHD00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:26:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56336 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab3BHD0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:26:25 -0500
Date: Thu, 07 Feb 2013 22:26:21 -0500 (EST)
Message-Id: <20130207.222621.219382606390584516.davem@davemloft.net>
To: normalperson@yhbt.net
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, w@1wt.eu
Subject: Re: splice() giving unexpected EOF in 3.7.3 and 3.8-rc4+
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130208023946.GA23197@dcvr.yhbt.net>
References: <1358575996.3464.447.camel@edumazet-glaptop>
	<20130120.232122.1798689273842981732.davem@davemloft.net>
	<20130208023946.GA23197@dcvr.yhbt.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Wong <normalperson@yhbt.net>
Date: Fri, 8 Feb 2013 02:39:46 +0000

> David Miller <davem@davemloft.net> wrote:
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Fri, 18 Jan 2013 22:13:16 -0800
>> 
>> > On Fri, 2013-01-18 at 21:54 -0800, Eric Dumazet wrote:
>> > 
>> >> 
>> >> Hmm, this might be already fixed in net-next tree, could you try it ?
>> >> 
>> > 
>> > Yes, running your program on net-next seems OK.
>> > 
>> > David, we need the two following commits.
>> 
>> Tossed into 'net' and queued up for -stable, thanks.
> 
> Hi David, any update on getting these into -stable?  Thanks.

I submit stable patches once they have cooked upstream for
a week or two.
