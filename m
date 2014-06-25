Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaFYEBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:01:35 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:39875 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaFYEB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:01:27 -0400
Date: Wed, 25 Jun 2014 00:01:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH -mm 1/3] page-cgroup: trivial cleanup
Message-ID: <20140625040118.GP7331@cmpxchg.org>
References: <9f5abf8dcb07fe5462f12f81867f199c22e883d3.1403626729.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f5abf8dcb07fe5462f12f81867f199c22e883d3.1403626729.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 08:33:04PM +0400, Vladimir Davydov wrote:
> Add forward declarations for struct pglist_data, mem_cgroup.
> 
> Remove __init, __meminit from function prototypes and inline functions.
> 
> Remove redundant inclusion of bit_spinlock.h.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
