Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447AbaFSSWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:22:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933553AbaFSSWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:22:23 -0400
Date: Thu, 19 Jun 2014 21:22:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nab@linux-iscsi.org
Subject: Re: linux-next: Tree for Jun 19 (vhost_scsi)
Message-ID: <20140619182219.GA22644@redhat.com>
References: <20140619161632.58b442e4@canb.auug.org.au>
 <53A31ACF.5020302@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A31ACF.5020302@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:15:59AM -0700, Randy Dunlap wrote:
> On 06/18/14 23:16, Stephen Rothwell wrote:
> > Hi all,
> > 
> > The powerpc allyesconfig is again broken more than usual.
> > 
> > Changes since 20140618:
> > 
> 
> on x86_64:
> CONFIG_NET is not enabled.
> 
> ERROR: "memcpy_fromiovecend" [drivers/vhost/vhost_scsi.ko] undefined!
> 
> drivers/vhost/scsi.c calls memcpy_fromiovecend().
> This function is not available when CONFIG_NET is not enabled.

Yes, that's nab's tree using memcpy_fromiovecend.
I'll send a patch to fix that.

> 
> -- 
> ~Randy
