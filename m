Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3HUMED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3HUMEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:04:00 -0400
Date: Wed, 21 Aug 2013 14:03:50 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        bufferbloat-list <bloat@lists.bufferbloat.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Dave Taht <dave.taht@gmail.com>
Subject: Re: ADSL/ATM linklayer tc shaping regression fix commits for stable
Message-ID: <20130821140350.2b953007@redhat.com>
In-Reply-To: <20130820151650.GA18016@kroah.com>
References: <20130820132629.51618797@redhat.com>
	<20130820151650.GA18016@kroah.com>
Organization: Red Hat Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 Aug 2013 08:16:50 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Tue, Aug 20, 2013 at 01:26:29PM +0200, Jesper Dangaard Brouer wrote:
[...]
 
> If there are issues with 3.10, that's a different story.
> 
> > Refactor improvements (v3.11-rc1):
> >  commit 130d3d68b52 (net_sched: psched_ratecfg_precompute() improvements)

Needed because it fixes the accuracy of the rate calc.

> > The linklayer ATM/ADSL fix, reached 3.11-rc6:
> >  commit 8a8e3d84b17 (net_sched: restore "linklayer atm" handling)

Needed because we broke userspace interface.

> David sends me the networking patches for the stable tree, and if he
> thinks these are applicable, then I'll take them.

DaveM, please?  What do you want me to do, submit this req/patches somehow?

(Can see that is not currently on your stable queue via:
http://patchwork.ozlabs.org/bundle/davem/stable/?state=*)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
