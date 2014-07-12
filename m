Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaGLQ6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 12:58:07 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58260 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbaGLQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 12:58:04 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jul 2014 12:58:04 EDT
X-Sasl-enc: 7MIiNcNf7PF/FK+id3KGyc+ZH4lvj+8SiuAo5S1G+jbg 1405183760
Date: Sat, 12 Jul 2014 09:53:49 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Kristina =?utf-8?Q?Mart=C5=A1enko?= 
	<kristina.martsenko@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the  tree
Message-ID: <20140712165349.GC12148@kroah.com>
References: <20140711152130.45a6978f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711152130.45a6978f@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:21:30PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/dgrp/dgrp_tty.c between commit e359a4e38d22 ("tty:
> Remove tty_hung_up_p() tests from tty drivers' open()") from the tty
> tree and commit 19b1e7695be8 ("staging: dgrp: remove driver") from the
> staging tree.
> 
> I fixed it up (by just removing the file) and can carry the fix as
> necessary (no action is required).

That sounds fine, thanks.

greg k-h
