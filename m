Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3BDXHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:07:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3BDXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:06:59 -0500
Date: Mon, 4 Feb 2013 15:06:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, minchan@kernel.org,
        mgorman@suse.de, kyungmin.park@samsung.com
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high
 memory
Message-Id: <20130204150657.6d05f76a.akpm@linux-foundation.org>
In-Reply-To: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2013 11:27:05 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> The total number of low memory pages is determined as
> totalram_pages - totalhigh_pages, so without this patch all CMA
> pageblocks placed in highmem were accounted to low memory.

What are the end-user-visible effects of this bug?

(This information is needed so that others can make patch-scheduling
decisions and should be included in all bugfix changelogs unless it is
obvious).

