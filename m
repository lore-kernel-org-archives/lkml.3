Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaKXSVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:21:53 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:50675 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaKXSVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:21:52 -0500
Date: Mon, 24 Nov 2014 13:21:27 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, mgorman@suse.de, riel@redhat.com,
        sasha.levin@oracle.com, n-horiguchi@ah.jp.nec.com,
        andriy.shevchenko@linux.intel.com, rientjes@google.com,
        vdavydov@parallels.com, fabf@skynet.be, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jianyu Zhan <jianyu.zhan@emc.com>
Subject: Re: [PATCH] mm, gfp: escalatedly define GFP_HIGHUSER and
 GFP_HIGHUSER_MOVABLE
Message-ID: <20141124182127.GA7604@phnom.home.cmpxchg.org>
References: <1416847427-2550-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416847427-2550-1-git-send-email-nasa4836@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:43:47AM +0800, Jianyu Zhan wrote:
> GFP_USER, GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE are escalatedly
> confined defined, also implied by their names:
> 
> GFP_USER                                  = GFP_USER
> GFP_USER + __GFP_HIGHMEM                  = GFP_HIGHUSER
> GFP_USER + __GFP_HIGHMEM + __GFP_MOVABLE  = GFP_HIGHUSER_MOVABLE
> 
> So just make GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE escalatedly defined
> to reflect this fact. It also makes the definition clear and texturally
> warn on any furture break-up of this escalated relastionship.
> 
> Signed-off-by: Jianyu Zhan <jianyu.zhan@emc.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
