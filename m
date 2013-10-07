Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3JGVVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:21:38 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:57275 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3JGVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:21:35 -0400
Date: Tue, 8 Oct 2013 01:21:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] smaps: show VM_SOFTDIRTY flag in VmFlags line
Message-ID: <20131007212133.GL6036@moon>
References: <1380913335-17466-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <5252B56C.8030903@parallels.com>
 <1381155304-2ro6e10t-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381155304-2ro6e10t-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:15:04AM -0400, Naoya Horiguchi wrote:
> > 
> > The comment is not correct. Per-VMA soft-dirty flag means, that
> > VMA is "newly created" one and thus represents a new (dirty) are
> > in task's VM.
> 
> Thanks for the correction. I changed the description.

Looks good to me, thanks!

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
