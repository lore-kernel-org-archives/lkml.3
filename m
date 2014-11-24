Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaKXVei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:34:38 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52173 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKXVeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:34:37 -0500
Date: Mon, 24 Nov 2014 13:34:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jianyu Zhan <nasa4836@gmail.com>
cc: akpm@linux-foundation.org, mgorman@suse.de, riel@redhat.com,
        sasha.levin@oracle.com, n-horiguchi@ah.jp.nec.com,
        andriy.shevchenko@linux.intel.com, hannes@cmpxchg.org,
        vdavydov@parallels.com, fabf@skynet.be, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jianyu Zhan <jianyu.zhan@emc.com>
Subject: Re: [PATCH] mm, gfp: escalatedly define GFP_HIGHUSER and
 GFP_HIGHUSER_MOVABLE
In-Reply-To: <1416847427-2550-1-git-send-email-nasa4836@gmail.com>
Message-ID: <alpine.DEB.2.10.1411241334210.21237@chino.kir.corp.google.com>
References: <1416847427-2550-1-git-send-email-nasa4836@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Jianyu Zhan wrote:

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

Acked-by: David Rientjes <rientjes@google.com>
