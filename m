Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904Ab3BTHaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:30:08 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42046
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933849Ab3BTHaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:30:07 -0500
Date: Wed, 20 Feb 2013 08:28:35 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.9
Message-ID: <20130220072835.GP4768@kernel.dk>
References: <20130220025703.GA26463@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220025703.GA26463@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2013, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.9
> 
> which has bug-fixes that did not make it in v3.8. They all are marked as
> material for the stable tree as well. There are two bug-fixes for
> the code that has been in there for some time (that is the Jan's fix
> and one of mine). And there are two bug-fixes for the persistent grant
> feature that debuted in v3.8 for xen blk[back|front]end.

Konrad, the tree is against 3.8, so I'm pulling it into my for-linus
branch which will be pushed a bit after the initial for-3.9/drivers goes
out. I can't pull it into the latter without getting a whole lot of
extra changes too.

-- 
Jens Axboe

