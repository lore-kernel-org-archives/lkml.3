Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab3C1Rhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:37:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19340 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3C1Rhe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:37:34 -0400
MIME-Version: 1.0
Message-ID: <125abdf8-0af9-447b-8782-68acf1c9c229@default>
Date: Thu, 28 Mar 2013 10:35:52 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Bob Liu <bob.liu@oracle.com>
Subject: RE: [RFC] mm: remove swapcache page early
References: <1364350932-12853-1-git-send-email-minchan@kernel.org>
 <alpine.LNX.2.00.1303271230210.29687@eggly.anvils>
 <433aaa17-7547-4e39-b472-7060ee15e85f@default>
 <alpine.LNX.2.00.1303271541200.30535@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1303271541200.30535@eggly.anvils>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Hugh Dickins [mailto:hughd@google.com]
> Subject: RE: [RFC] mm: remove swapcache page early
> 
> On Wed, 27 Mar 2013, Dan Magenheimer wrote:
> > > From: Hugh Dickins [mailto:hughd@google.com]
> > > Subject: Re: [RFC] mm: remove swapcache page early
> > >
> > The issue you are raising
> > here is (2).  You may not know that (2) has recently been solved
> > in frontswap, at least for zcache.  See frontswap_exclusive_gets_enabled.
> > If this is enabled (and it is for zcache but not yet for zswap),
> > what you suggest (SetPageDirty) is what happens.
> 
> Ah, and I have a dim, perhaps mistaken, memory that I gave you
> input on that before, suggesting the SetPageDirty.  Good, sounds
> like the solution is already in place, if not actually activated.
> 
> Thanks, must dash,
> Hugh

Hi Hugh --

Credit where it is due...  Yes, I do recall now that the idea
was originally yours.  It went on a to-do list where I eventually
tried it and it worked... I'm sorry I had forgotten and neglected
to give you credit!

(BTW, it is activated for zcache in 3.9.)

Thanks,
Dan
