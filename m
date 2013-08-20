Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3HTPPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:15:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3HTPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:15:00 -0400
Date: Tue, 20 Aug 2013 08:16:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        bufferbloat-list <bloat@lists.bufferbloat.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Dave Taht <dave.taht@gmail.com>
Subject: Re: ADSL/ATM linklayer tc shaping regression fix commits for stable
Message-ID: <20130820151650.GA18016@kroah.com>
References: <20130820132629.51618797@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820132629.51618797@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 01:26:29PM +0200, Jesper Dangaard Brouer wrote:
> Hi Greg (and google search),
> 
> ADSL/ATM linklayer shaping were broken in kernel release from 3.8 to
> 3.10 by commit 56b765b79 ("htb: improved accuracy at high rates").
> 
> I can see that 3.9-stable is marked EOL, and 3.8-stable also seems
> closed.  I guess it is up to Greg, how far the commits described below
> can be backported.  Below is the commit needed for a 3.9 backport.

As you say, 3.8 and 3.9 are end-of-life, so there's nothing I can, or
even want, to do with them, sorry.

If there are issues with 3.10, that's a different story.

> Refactor improvements (v3.11-rc1):
>  commit 130d3d68b52 (net_sched: psched_ratecfg_precompute() improvements)
> 
> The linklayer ATM/ADSL fix, reached 3.11-rc6:
>  commit 8a8e3d84b17 (net_sched: restore "linklayer atm" handling)

David sends me the networking patches for the stable tree, and if he
thinks these are applicable, then I'll take them.

thanks,

greg k-h
