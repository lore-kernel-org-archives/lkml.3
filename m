Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab3JOPLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:11:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59063 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3JOPLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:11:04 -0400
Date: Tue, 15 Oct 2013 09:11:00 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        linux-kernel@vger.kernel.org
Subject: Re: blk-mq: mtip32xx: set numa node in blk_mq_reg structure
Message-ID: <20131015151100.GJ541@kernel.dk>
References: <x49hacja7ew.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49hacja7ew.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14 2013, Jeff Moyer wrote:
> Hi,
> 
> The mtip32xx driver figures out its numa node, but never updates its
> blk_mq_reg structure.
> 
> Patch against the new-queue branch of linux-block.git.

Thanks Jeff, applied.

-- 
Jens Axboe

