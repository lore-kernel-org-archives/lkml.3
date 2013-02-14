Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703Ab3BNPd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:33:56 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45652
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934562Ab3BNPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:33:55 -0500
Date: Thu, 14 Feb 2013 16:32:35 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] removal of 1980s PC-XT MFM 8bit ISA disk driver
Message-ID: <20130214153235.GR21269@kernel.dk>
References: <20130213200432.GA11018@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213200432.GA11018@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13 2013, Paul Gortmaker wrote:
> Jens,
> 
> Please pull the following to get the removal of the original IBM PC-XT
> hard disk driver from the block layer (drivers/block/xd.c).
> 
> As near as I can tell, it hasn't seen a run time fix in over a dozen
> years, and with drive sizes of 10-20MB, and performance of about 128kB/s
> maximum, it is no surprise that it has been completely unused for well
> over a decade.
> 
> The removal was originally posted[1] well over a month ago, and since
> then, there has been nobody objecting to the removal, aside from someone
> who had mistakenly confused it with a completely different driver (hd.c)
> 
> I've done a test merge followed by an allmodconfig/allyesconfig for
> x86-64 on the "for-next" branch of:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> 
> to ensure that there was no Makefile/Kconfig fallout since the 3.8-rc2
> the original commit was created and tested on.
> 
> [1] https://patchwork.kernel.org/patch/1935381/

Pulled, I'm pretty sure this hasn't been used in a decade at least. In
any case, it sits there nicely in history if someone wants to resurrect
it.

-- 
Jens Axboe

