Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaL2RDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:03:18 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:55876 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaL2RDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:03:17 -0500
Date: Mon, 29 Dec 2014 12:03:03 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH TRIVIAL] swap: remove unused
 mem_cgroup_uncharge_swapcache declaration
Message-ID: <20141229170303.GA12389@phnom.home.cmpxchg.org>
References: <1419854337-15161-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419854337-15161-1-git-send-email-vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 02:58:57PM +0300, Vladimir Davydov wrote:
> The body of this function was removed by commit 0a31bc97c80c ("mm:
> memcontrol: rewrite uncharge API").
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
