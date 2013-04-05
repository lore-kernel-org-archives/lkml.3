Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161056Ab3DEBpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:45:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46073 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932346Ab3DEBpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:45:07 -0400
X-Sasl-enc: sc6a8b1Ph9GsbWQ1SF8LFtTslO86tOBFOJsDytFpaJqt 1365126306
Date: Thu, 4 Apr 2013 18:45:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20130405014505.GB26617@kroah.com>
References: <20130404154017.baa42c6bcef82c4cbc750646@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404154017.baa42c6bcef82c4cbc750646@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 03:40:17PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/dgrp/dgrp_specproc.c between commit 464b4fd02caa ("dgrp
> procfs fixes, part 2") and various other commits from the vfs tree and
> commit 433121c6ef51 ("staging: dgrp: cleanup sparse warnings") from the
> staging tree.
> 
> I just used the version from the vfs tree and can carry the fix as
> necessary (no action is required).

That is correct, thanks.

greg k-h
