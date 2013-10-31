Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3JaT5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:57:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47745 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3JaT5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:57:18 -0400
Date: Thu, 31 Oct 2013 12:57:15 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: update bi_remaining to relfect our bio endio
 chaining
Message-ID: <20131031195715.GC27129@kmo>
References: <20131031193820.10239.79827@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031193820.10239.79827@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:38:20PM -0400, Chris Mason wrote:
> Btrfs is sometimes calling bio_endio twice on the same bio while
> we chain things.  This makes sure we don't trip over new assertions in
> fs/bio.c
> 
> Signed-off-by: Chris Mason <chris.mason@fusionio.com>

Beat me to it :P

Tested-by: Kent Overstreet <kmo@daterainc.com>
