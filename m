Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab3GCO4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:56:05 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:57247 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab3GCO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:56:04 -0400
Date: Wed, 3 Jul 2013 15:55:56 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] hugetlb: properly account rss
Message-ID: <20130703145555.GA7449@linaro.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
 <1371581225-27535-2-git-send-email-joern@logfs.org>
 <20130703134118.GA4978@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703134118.GA4978@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 02:41:19PM +0100, Steve Capper wrote:

[ ... ]

> Excluding VM_SHARED VMAs from the counter increment/decrement stopped the
> warnings for me.

Whoops sorry, the fork copy on write test flagged a BUG, hugetlb_cow will need
to be examined too.

Cheers,
-- 
Steve

