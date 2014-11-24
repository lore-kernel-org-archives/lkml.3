Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaKXTCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:02:04 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:50127 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbaKXTCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:02:01 -0500
Date: Mon, 24 Nov 2014 21:01:27 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, mgorman@suse.de, riel@redhat.com,
        sasha.levin@oracle.com, n-horiguchi@ah.jp.nec.com,
        andriy.shevchenko@linux.intel.com, rientjes@google.com,
        hannes@cmpxchg.org, vdavydov@parallels.com, fabf@skynet.be,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jianyu Zhan <jianyu.zhan@emc.com>
Subject: Re: [PATCH] mm, gfp: escalatedly define GFP_HIGHUSER and
 GFP_HIGHUSER_MOVABLE
Message-ID: <20141124190127.GA5027@node.dhcp.inet.fi>
References: <1416847427-2550-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416847427-2550-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
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

Looks reasonable.

Acked-by: Kirill A. Shutemov <kirill@linux.intel.com>

But I would prefer to have GPF_HIGHUSER movable by default and
GFP_HIGHUSER_UNMOVABLE to opt out.

-- 
 Kirill A. Shutemov
