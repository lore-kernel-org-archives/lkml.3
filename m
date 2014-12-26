Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaLZU7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 15:59:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:56353 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaLZU7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 15:59:22 -0500
Date: Fri, 26 Dec 2014 12:59:05 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changman Lee <cm224.lee@samsung.com>
Subject: Re: linux-next: Tree for Dec 26 (f2fs)
Message-ID: <20141226205822.GA21870@jaegeuk-mac02>
References: <20141226193009.60d3f62e@canb.auug.org.au>
 <549DB43B.7050902@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549DB43B.7050902@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the merged patch directly.

Changman,
The patch was initially made by you, so let me know, if you have objection.

Thanks,

On Fri, Dec 26, 2014 at 11:17:15AM -0800, Randy Dunlap wrote:
> On 12/26/14 00:30, Stephen Rothwell wrote:
> > Hi all,
> > 
> > There will only be intermittent releases of linux-next between now and
> > Jan 5.
> > 
> > Changes since 20141221:
> > 
> 
> on x86_64:
> when CONFIG_F2FS_STAT_FS is not enabled:
> 
> ../fs/f2fs/segment.c: In function 'rewrite_data_page':
> ../fs/f2fs/segment.c:1233:2: error: implicit declaration of function 'stat_inc_inplace_blocks' [-Werror=implicit-function-declaration]
> 
> 
> 
> -- 
> ~Randy
