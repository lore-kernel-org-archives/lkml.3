Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3KIT4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 14:56:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44253 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab3KIT4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 14:56:41 -0500
Date: Sat, 09 Nov 2013 14:56:37 -0500 (EST)
Message-Id: <20131109.145637.1963860932249813503.davem@davemloft.net>
To: jason@lakedaemon.net
Cc: sebastian.hesselbarth@gmail.com, buytenh@wantstofly.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: mv643xx_eth: take over maintainership
 from Lennart
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131004130707.GZ31178@titan.lakedaemon.net>
References: <1380884199-25025-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20131004130707.GZ31178@titan.lakedaemon.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 09 Nov 2013 11:56:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Cooper <jason@lakedaemon.net>
Date: Fri, 4 Oct 2013 09:07:07 -0400

> On Fri, Oct 04, 2013 at 12:56:39PM +0200, Sebastian Hesselbarth wrote:
>> Lennart says: "I haven't been able to spend time on mv643xx_eth for a
>> while now, so if you want to take over maintainership, I'd be fine with
>> that."
>> 
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
>> ---
>> TBH, I have no clue about netdev internals, yet. But if David and Jason
>> Cooper promise to have one eye each on the first Acks, I am willing to
>> take over maintainership.
> 
> If David is ok with it,
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>

This got lost in the noise because it didn't get sent to netdev, I've
applied it now.
