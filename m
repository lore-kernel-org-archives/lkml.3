Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab3ASHEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 02:04:38 -0500
Received: from 1wt.eu ([62.212.114.60]:41825 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab3ASHEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 02:04:36 -0500
Date: Sat, 19 Jan 2013 08:04:27 +0100
From: Willy Tarreau <w@1wt.eu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Wong <normalperson@yhbt.net>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: splice() giving unexpected EOF in 3.7.3 and 3.8-rc4+
Message-ID: <20130119070427.GC6838@1wt.eu>
References: <20130119044957.GA25395@dcvr.yhbt.net> <1358574847.3464.422.camel@edumazet-glaptop> <1358575996.3464.447.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358575996.3464.447.camel@edumazet-glaptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:13:16PM -0800, Eric Dumazet wrote:
> On Fri, 2013-01-18 at 21:54 -0800, Eric Dumazet wrote:
> 
> > 
> > Hmm, this might be already fixed in net-next tree, could you try it ?
> > 
> 
> Yes, running your program on net-next seems OK.
> 
> David, we need the two following commits.
> 
> They actually fixed a bug : current code in Linus tree
> can push to the pipe a 0-length frag, because of the :
(...)

And FWIW I confirm that my test machines which have been running 3.7
with these two patches since you proposed them have never experienced
such an issue.

Willy

