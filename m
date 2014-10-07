Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaJGGpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbaJGGpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:45:49 -0400
Date: Tue, 7 Oct 2014 09:49:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/16] virtio_net: drop config_enable
Message-ID: <20141007064915.GA2424@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
 <1412525038-15871-9-git-send-email-mst@redhat.com>
 <20141006.150238.2180269239953265506.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006.150238.2180269239953265506.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 03:02:38PM -0400, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 5 Oct 2014 19:07:13 +0300
> 
> > Now that virtio core ensures config changes don't arrive during probing,
> > drop config_enable flag in virtio net.
> > On removal, flush is now sufficient to guarantee that no change work is
> > queued.
> > 
> > This help simplify the driver, and will allow setting DRIVER_OK earlier
> > without losing config change notifications.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> It's hard for people on the networking side to review these changes
> since you haven't CC:'d them on any of the postings necessary to
> understand the context of the net/ and drivers/net/ changes.
> 
> Please at a minimum CC: everyone on your header [PATCH 0/N] posting
> so we know at least at a high level what is going on, and why.
> 
> Thanks.

It's a bit tricky for large patchsets - if I add everyone to 0/N
then vger isn't happy with Cc list that is too large.

What is your advice here? Cc just mailing lists on 0/N?

FWIW this patchset is inteded for the virtio tree.

-- 
MST
