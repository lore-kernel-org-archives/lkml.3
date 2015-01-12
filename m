Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbbALLWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:22:36 -0500
Received: from mx2.parallels.com ([199.115.105.18]:33650 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbALLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:22:34 -0500
Date: Mon, 12 Jan 2015 14:22:27 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] mm: memcontrol: consolidate swap controller code
Message-ID: <20150112112227.GD384@esperanza>
References: <1420856041-27647-1-git-send-email-hannes@cmpxchg.org>
 <1420856041-27647-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420856041-27647-3-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 09:14:01PM -0500, Johannes Weiner wrote:
> The swap controller code is scattered all over the file.  Gather all
> the code that isn't directly needed by the memory controller at the
> end of the file in its own CONFIG_MEMCG_SWAP section.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

I was always wondering why it had to be scattered all over the place. I
guess we'll have to do the same for the kmem part.

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
