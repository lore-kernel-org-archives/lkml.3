Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3HEFnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 01:43:40 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:32782 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3HEFnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 01:43:39 -0400
Date: Mon, 5 Aug 2013 09:43:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, luto@amacapital.net, xemul@parallels.com,
        akpm@linux-foundation.org, mpm@selenic.com,
        xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com,
        kosaki.motohiro@gmail.com, sfr@canb.auug.org.au, peterz@infradead.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 1/2] [PATCH] mm: Save soft-dirty bits on swapped pages
Message-ID: <20130805054335.GC7999@moon>
References: <20130730204154.407090410@gmail.com>
 <20130730204654.844299768@gmail.com>
 <51ff047d.2768310a.2fc4.340fSMTPIN_ADDED_BROKEN@mx.google.com>
 <20130805021715.GJ32486@bbox>
 <51ff1053.ab47310a.5d3f.566cSMTPIN_ADDED_BROKEN@mx.google.com>
 <20130805025437.GK32486@bbox>
 <51ff14e9.87ef440a.1424.ffffe470SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ff14e9.87ef440a.1424.ffffe470SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:58:35AM +0800, Wanpeng Li wrote:
> >
> >pte_to_swp_entry is passed orig_pte by vaule, not a pointer
> >so although pte_to_swp_entry clear out _PTE_SWP_SOFT_DIRTY, it does it in local-copy.
> >So orig_pte is never changed.
> 
> Ouch! Thanks for pointing out. ;-)
> 
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Yeah, it's a bit tricky. Thanks.
