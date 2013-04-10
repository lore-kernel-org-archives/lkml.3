Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936926Ab3DJO5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:57:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37081 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936634Ab3DJO5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:57:30 -0400
X-Sasl-enc: 4glzgsZHnAI5Gnijllq+ecCoQ1FM5DFq34uJmNaCd+zK 1365605849
Date: Wed, 10 Apr 2013 07:57:27 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20130410145727.GA19302@kroah.com>
References: <20130410155451.2792f82efeaf37b6e5889ea8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410155451.2792f82efeaf37b6e5889ea8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 03:54:51PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/vt6655/device_main.c between commit f805442e130c
> ("vt6655: slightly clean reading config file") from the vfs tree and
> commits 915006cddc79 ("staging:vt6655:device_main: Whitespace cleanups")
> and 5e0cc8a231be ("staging: vt6655: Convert to kernel brace style") from
> the staging tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).

Looks correct to me, thanks.

greg k-h
