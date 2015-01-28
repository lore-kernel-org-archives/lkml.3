Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbbA1Ufa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:35:30 -0500
Received: from verein.lst.de ([213.95.11.211]:34401 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760700AbbA1Uf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:27 -0500
Date: Wed, 28 Jan 2015 17:55:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mtd@lists.infradead.org, Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: export new mtd_mmap_capabilities
Message-ID: <20150128165536.GA17313@lst.de>
References: <1900951.4yX9yJNQM5@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1900951.4yX9yJNQM5@wuerfel>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 04:19:31PM +0100, Arnd Bergmann wrote:
> The recently added mtd_mmap_capabilities can be used from loadable
> modules, in particular romfs, but is not exported, so we get
> 
> ERROR: "mtd_mmap_capabilities" [fs/romfs/romfs.ko] undefined!
> 
> This adds the missing export.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: b4caecd48005f ("fs: introduce f_op->mmap_capabilities for nommu mmap support")

Thanks, this looks fine to me:

Acked-by: Christoph Hellwig <hch@lst.de>
