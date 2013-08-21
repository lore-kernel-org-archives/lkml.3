Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3HUSUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:20:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34536 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3HUSUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:20:25 -0400
Date: Wed, 21 Aug 2013 11:20:23 -0700 (PDT)
Message-Id: <20130821.112023.744177612387539958.davem@davemloft.net>
To: brouer@redhat.com
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bloat@lists.bufferbloat.net,
        eric.dumazet@gmail.com, dave.taht@gmail.com
Subject: Re: ADSL/ATM linklayer tc shaping regression fix commits for stable
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130821140350.2b953007@redhat.com>
References: <20130820132629.51618797@redhat.com>
	<20130820151650.GA18016@kroah.com>
	<20130821140350.2b953007@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 21 Aug 2013 11:20:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 21 Aug 2013 14:03:50 +0200

> 
> On Tue, 20 Aug 2013 08:16:50 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> On Tue, Aug 20, 2013 at 01:26:29PM +0200, Jesper Dangaard Brouer wrote:
> [...]
>  
>> If there are issues with 3.10, that's a different story.
>> 
>> > Refactor improvements (v3.11-rc1):
>> >  commit 130d3d68b52 (net_sched: psched_ratecfg_precompute() improvements)
> 
> Needed because it fixes the accuracy of the rate calc.
> 
>> > The linklayer ATM/ADSL fix, reached 3.11-rc6:
>> >  commit 8a8e3d84b17 (net_sched: restore "linklayer atm" handling)
> 
> Needed because we broke userspace interface.
> 
>> David sends me the networking patches for the stable tree, and if he
>> thinks these are applicable, then I'll take them.
> 
> DaveM, please?  What do you want me to do, submit this req/patches somehow?
> 
> (Can see that is not currently on your stable queue via:
> http://patchwork.ozlabs.org/bundle/davem/stable/?state=*)

I'll put it there, you just have to formally ask me to do it that's
all.

Asking Greg to do it directly is a complete waste of time. :-)

