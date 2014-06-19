Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbaFSHOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:14:14 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51013 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaFSHON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:14:13 -0400
Date: Thu, 19 Jun 2014 11:14:04 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: <akpm@linux-foundation.org>, <rientjes@google.com>, <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fork: dup_mm: init vm stat counters under mmap_sem
Message-ID: <20140619071404.GA20390@esperanza>
References: <1403098391-24546-1-git-send-email-vdavydov@parallels.com>
 <20140618152209.GA14818@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140618152209.GA14818@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 05:22:09PM +0200, Oleg Nesterov wrote:
> But perhaps this deserves more cleanups, with or without this patch
> the initialization does not look consistent. dup_mmap() nullifies
> locked_vm/pinned_vm/mmap/map_count while mm_init() clears core_state/
> nr_ptes/rss_stat.

Agree. Will try to clean this up.

Thanks.
