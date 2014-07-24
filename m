Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbaGXGXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:23:51 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60774 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521AbaGXGXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:23:50 -0400
X-Sasl-enc: Fu3IpQBzoFVKXO9g6eSlbvb68OhB/udCGsxqfOf7JJwX 1406183028
Date: Wed, 23 Jul 2014 23:23:23 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the driver-core tree with the drm
 tree
Message-ID: <20140724062323.GC19567@kroah.com>
References: <20140724155630.2727ad65@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724155630.2727ad65@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 03:56:30PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/gpu/drm/armada/armada_crtc.c between commit d8c96083cf5e
> ("drm/armada: permit CRTCs to be registered as separate devices") from
> the drm tree and commit c9d53c0f2d23 ("devres: remove
> devm_request_and_ioremap()") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
