Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab3BHCjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:39:48 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:48029 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758260Ab3BHCjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:39:47 -0500
Date: Fri, 8 Feb 2013 02:39:46 +0000
From: Eric Wong <normalperson@yhbt.net>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, w@1wt.eu
Subject: Re: splice() giving unexpected EOF in 3.7.3 and 3.8-rc4+
Message-ID: <20130208023946.GA23197@dcvr.yhbt.net>
References: <20130119044957.GA25395@dcvr.yhbt.net>
 <1358574847.3464.422.camel@edumazet-glaptop>
 <1358575996.3464.447.camel@edumazet-glaptop>
 <20130120.232122.1798689273842981732.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120.232122.1798689273842981732.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Fri, 18 Jan 2013 22:13:16 -0800
> 
> > On Fri, 2013-01-18 at 21:54 -0800, Eric Dumazet wrote:
> > 
> >> 
> >> Hmm, this might be already fixed in net-next tree, could you try it ?
> >> 
> > 
> > Yes, running your program on net-next seems OK.
> > 
> > David, we need the two following commits.
> 
> Tossed into 'net' and queued up for -stable, thanks.

Hi David, any update on getting these into -stable?  Thanks.
