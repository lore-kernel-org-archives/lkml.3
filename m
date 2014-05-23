Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaEWRyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:54:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39871 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaEWRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:54:34 -0400
Date: Fri, 23 May 2014 13:54:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com
Subject: Re: [PATCH RESEND 0/3] xen-block: changes for discard support
Message-ID: <20140523175422.GA9131@phenom.dumpdata.com>
References: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400682762-17429-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 04:32:39PM +0200, Olaf Hering wrote:
> Fix blkfront to handle all sorts of backends.
> 
> Also let blkback recognize a xenstore property to disable discard for a
> given device. This part requires libxl changes ("discard-enable"):
> http://lists.xenproject.org/archives/html/xen-devel/2014-05/msg02291.html
> 
> (This is a resend, this series was already sent 2014-02-10.)

Applied to 'devel/for-jens-3.16'

Thank you for reposting!
> 
> Olaf Hering (3):
>   xen-blkfront: remove type check from blkfront_setup_discard
>   xen blkif.h: fix comment typo in discard-alignment
>   xen/blkback: disable discard feature if requested by toolstack
> 
>  drivers/block/xen-blkback/xenbus.c |  7 ++++++-
>  drivers/block/xen-blkfront.c       | 40 +++++++++++++-------------------------
>  include/xen/interface/io/blkif.h   |  2 +-
>  3 files changed, 21 insertions(+), 28 deletions(-)
> 
