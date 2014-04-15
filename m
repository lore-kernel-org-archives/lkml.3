Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaDOS3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:29:40 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:45660 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaDOS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:29:38 -0400
Date: Tue, 15 Apr 2014 22:29:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        xemul@parallels.com, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [patch 4/4] mm: Clear VM_SOFTDIRTY flag inside clear_refs_write
 instead of clear_soft_dirty
Message-ID: <20140415182935.GR23983@moon>
References: <20140324122838.490106581@openvz.org>
 <20140324125926.204897920@openvz.org>
 <20140415110654.4dd9a97c216e2689316fa448@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415110654.4dd9a97c216e2689316fa448@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:06:54AM -0700, Andrew Morton wrote:
> 
> I resolved this by merging
> mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
> on top of the pagewalk patches as below - please carefully review.

Thanks a lot, Andrew! I've updated the patches and were planning to send them to you
tonightm but because you applied it on top of pagewal patches, I think i rather need to
fetch -next repo and review this patch and update the rest of the series on top (hope
i'll do that in 3-4 hours).

> 
> I'm hoping we'll be able to get the pagewalk patches merged in 3.16-rc1
> - we'll see what happens when the testing gets underway again.
