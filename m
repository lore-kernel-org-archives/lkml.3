Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072Ab3DEBpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:45:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58100 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161059Ab3DEBpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:45:20 -0400
X-Sasl-enc: eWciqHaLlnDxcW3PRiKwRCC97a12+eRfyw7pOEqKxEu2 1365126320
Date: Thu, 4 Apr 2013 18:45:18 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20130405014518.GC26617@kroah.com>
References: <20130404153433.be980c842e6b7a41afa0168f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404153433.be980c842e6b7a41afa0168f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 03:34:33PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got conflicts in
> drivers/staging/dgrp/dgrp_dpa_ops.c, drivers/staging/dgrp/dgrp_mon_ops.c,
> drivers/staging/dgrp/dgrp_net_ops.c and
> drivers/staging/dgrp/dgrp_ports_ops.c between commit 33633903f16f ("dgrp
> procfs fixes, part 5: per-node files") from the vfs tree and commit
> 433121c6ef51 ("staging: dgrp: cleanup sparse warnings") from the staging
> tree.
> 
> The former removed the code modified by the latter, so I just did that
> and can carry the fix as necessary (no action is required).

That is correct, thanks.

greg k-h
