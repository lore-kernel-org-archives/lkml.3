Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaL1KWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 05:22:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaL1KWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 05:22:14 -0500
Date: Sun, 28 Dec 2014 12:21:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
        sam@ravnborg.org, dave.kleikamp@oracle.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH repost 15/16] sparc/uaccess: fix sparse errors
Message-ID: <20141228102153.GA9251@redhat.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
 <1419499661-8566-16-git-send-email-mst@redhat.com>
 <20141225.183930.2234745020223954872.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141225.183930.2234745020223954872.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 06:39:30PM -0500, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Thu, 25 Dec 2014 11:30:22 +0200
> 
> > virtio wants to read bitwise types from userspace using get_user.  At the
> > moment this triggers sparse errors, since the value is passed through an
> > integer.
> > 
> > Fix that up using __force.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Patches #14 and #15 have identical commit message header lines, you
> need to say "sparc32: " or "sparc64: " so that shortlog scanners can
> distinguish them.
> 
> Thanks.

Got it.
Arnd, you are queueing this - could you tweak the subjects please?
Or would you prefer me to repost with tweaked subjects?

-- 
MST
