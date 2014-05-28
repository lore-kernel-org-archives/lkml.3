Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaE1Sua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:50:30 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38690 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbaE1Su2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:50:28 -0400
Message-ID: <53862FFE.6030103@kernel.dk>
Date: Wed, 28 May 2014 12:50:38 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.16
References: <20140528182414.GA22931@phenom.dumpdata.com>
In-Reply-To: <20140528182414.GA22931@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 12:24 PM, Konrad Rzeszutek Wilk wrote:
> 
> Dear Jens,
> 
> Please git pull the following branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.16
> 
> which has a bunch of fixes to the Xen block frontend and backend driver
> and a new parameter for Xen backend driver - an override (set by the toolstack)
> whether to expose the discard support (if disk of course supports it) or not.
> 
>  drivers/block/xen-blkback/common.h |  4 +--
>  drivers/block/xen-blkback/xenbus.c | 53 ++++++++++++++++++++++++++++----------
>  drivers/block/xen-blkfront.c       | 40 ++++++++++------------------
>  include/xen/interface/io/blkif.h   |  2 +-
>  4 files changed, 57 insertions(+), 42 deletions(-)
> 
> Olaf Hering (3):
>       xen-blkfront: remove type check from blkfront_setup_discard
>       xen/blkback: disable discard feature if requested by toolstack
>       xen blkif.h: fix comment typo in discard-alignment
> 
> Valentin Priescu (1):
>       xen-blkback: defer freeing blkif to avoid blocking xenwatch

Pulled, thanks.

-- 
Jens Axboe

