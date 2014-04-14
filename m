Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaDNAH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 20:07:59 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44915 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaDNAH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 20:07:57 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 14 Apr 2014 09:08:31 +0900
From: Minchan Kim <minchan@kernel.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, willy@linux.intel.com
Subject: Re: [PATCH v3 0/7] Page I/O
Message-ID: <20140414000831.GA30991@bbox>
References: <cover.1397429628.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1397429628.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 06:59:49PM -0400, Matthew Wilcox wrote:
> Hi Andrew,
> 
> Now that 3.15-rc1 is out, could you queue these patches for 3.16 please?
> Patches 1-3 & 7 are, IMO, worthwhile cleanups / bug fixes, regardless
> of the rest of the patch set.
> 
> If this patch series gets in, I'll take care of including the NVMe
> driver piece.  It'll be a bit more tricky than the proof of concept that
> I've been flashing around because we have to make sure that the device
> responds better to page sized I/Os than accumulating larger I/Os.
> 
> It's indisputably a win for brd and for other NVM technology devices
> that are accessed synchronously rather than through DMA.

FYI, It would be good for zram, too.
I support this patchset.

>-- 
Kind regards,
Minchan Kim
