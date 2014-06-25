Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaFYECG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:02:06 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:39880 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaFYECE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:02:04 -0400
Date: Wed, 25 Jun 2014 00:01:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH -mm 2/3] page-cgroup: get rid of NR_PCG_FLAGS
Message-ID: <20140625040159.GQ7331@cmpxchg.org>
References: <9f5abf8dcb07fe5462f12f81867f199c22e883d3.1403626729.git.vdavydov@parallels.com>
 <26252c1699103f7efe51b224dd61bdb74e31f255.1403626729.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26252c1699103f7efe51b224dd61bdb74e31f255.1403626729.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 08:33:05PM +0400, Vladimir Davydov wrote:
> It's not used anywhere today, so let's remove it.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
