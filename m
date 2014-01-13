Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaAMXNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:13:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaAMXNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:13:36 -0500
Date: Mon, 13 Jan 2014 15:13:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 4/5] mm: vmscan: move call to shrink_slab() to
 shrink_zones()
Message-Id: <20140113151334.996da9f248db297faeed1ed1@linux-foundation.org>
In-Reply-To: <1e31dd389002eca2533e6b112a774855426b1703.1389443272.git.vdavydov@parallels.com>
References: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com>
	<1e31dd389002eca2533e6b112a774855426b1703.1389443272.git.vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 16:36:34 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> This reduces the indentation level of do_try_to_free_pages() and removes
> extra loop over all eligible zones counting the number of on-LRU pages.

So this should cause no functional change, yes?
