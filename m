Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaDHOoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:44:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbaDHOoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:44:01 -0400
Date: Tue, 8 Apr 2014 16:43:59 +0200
From: Michal Marek <mmarek@suse.cz>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        "Yann E . MORIN" <yann.morin.1998@free.fr>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] scripts: objdiff: detect object code changes between
 two commits
Message-ID: <20140408144359.GA4894@sepie.suse.cz>
References: <1395627288-19975-1-git-send-email-jason@lakedaemon.net>
 <1396895429-27425-1-git-send-email-jason@lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396895429-27425-1-git-send-email-jason@lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 06:30:29PM +0000, Jason Cooper wrote:
> objdiff is useful when doing large code cleanups.  For example, when
> removing checkpatch warnings and errors from new drivers in the staging
> tree.
> 
> objdiff can be used in conjunction with a git rebase to confirm that
> each commit made no changes to the resulting object code.  It has the
> same return values as diff(1).
> 
> This was written specifically to support adding the skein and threefish
> cryto drivers to the staging tree.  I needed a programmatic way to
> confirm that commits changing >90% of the lines didn't inadvertently
> change the code.
> 
> Temporary files (objdump output) are stored in
> 
>   /path/to/linux/.tmp_objdiff
> 
> 'make mrproper' will remove this directory.
> 
> Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> ---
> Changes from V2:
> 
>  - use /path/to/linux/.tmp_objdiff instead of /tmp/objdiff (Michal Marek)
> 
>  - don't delete object files during record (Michal Marek)
> 
>  - remove .tmp_objdiff directory during 'make mrproper' (Michal Marek)

Applied to kbuild.git#misc, thanks.

Michal
