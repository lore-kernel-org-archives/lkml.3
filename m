Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaANGxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:53:20 -0500
Received: from relay.parallels.com ([195.214.232.42]:52661 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaANGxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:53:18 -0500
Message-ID: <52D4DED7.8090702@parallels.com>
Date: Tue, 14 Jan 2014 10:53:11 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 4/5] mm: vmscan: move call to shrink_slab() to shrink_zones()
References: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com> <1e31dd389002eca2533e6b112a774855426b1703.1389443272.git.vdavydov@parallels.com> <20140113151334.996da9f248db297faeed1ed1@linux-foundation.org>
In-Reply-To: <20140113151334.996da9f248db297faeed1ed1@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 03:13 AM, Andrew Morton wrote:
> On Sat, 11 Jan 2014 16:36:34 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> This reduces the indentation level of do_try_to_free_pages() and removes
>> extra loop over all eligible zones counting the number of on-LRU pages.
> So this should cause no functional change, yes?

Yes. This patch merely moves a piece of code from one function to another.

Thanks.
