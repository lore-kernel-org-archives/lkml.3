Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaJTSWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:22:07 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42391 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaJTSWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:22:05 -0400
Date: Mon, 20 Oct 2014 14:21:53 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] memcg: remove activate_kmem_mutex
Message-ID: <20141020182153.GA11973@phnom.home.cmpxchg.org>
References: <1413817889-13915-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413817889-13915-1-git-send-email-vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 07:11:29PM +0400, Vladimir Davydov wrote:
> The activate_kmem_mutex is used to serialize memcg.kmem.limit updates,
> but we already serialize them with memcg_limit_mutex so let's remove the
> former.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

It hid well behind this obscure name, but that's really all it seems
to do.  Away it goes!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
