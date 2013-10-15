Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3JOBza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 21:55:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51829 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3JOBz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 21:55:28 -0400
Date: Tue, 15 Oct 2013 10:55:18 +0900
From: Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Cc: Alexander Frolkin <avf@eldamar.org.uk>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        lvs-devel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] ipvs: improved SH fallback strategy
Message-ID: <20131015015518.GC6317@verge.net.au>
References: <20130923115139.GA15034@eldamar.org.uk>
 <524099BA.5020303@cogentembedded.com>
 <20130924093238.GD18494@eldamar.org.uk>
 <20130925003033.GG26081@verge.net.au>
 <20130925092638.GD19768@eldamar.org.uk>
 <alpine.LFD.2.00.1309260817290.1640@ja.ssi.bg>
 <20130926100540.GB27583@eldamar.org.uk>
 <alpine.LFD.2.00.1309262255400.1949@ja.ssi.bg>
 <20130927100622.GC28974@eldamar.org.uk>
 <alpine.LFD.2.00.1309272218180.1725@ja.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1309272218180.1725@ja.ssi.bg>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 10:20:42PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Fri, 27 Sep 2013, Alexander Frolkin wrote:
> 
> > Improve the SH fallback realserver selection strategy.
> > 
> > With sh and sh-fallback, if a realserver is down, this attempts to
> > distribute the traffic that would have gone to that server evenly
> > among the remaining servers.
> > 
> > Signed-off-by: Alexander Frolkin <avf@eldamar.org.uk>
> 
> 	Thanks! Looks good to me.
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Sorry for letting this one slip.
I have queued it up.
