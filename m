Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860Ab3LIIfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:35:48 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55761 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760057Ab3LIIfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:35:46 -0500
X-Sasl-enc: rbQqCZWVnjDqfMgGv3xnDCOgz95cofZ6XC820pkTl+pI 1386578144
Date: Mon, 9 Dec 2013 00:21:52 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-ID: <20131209082152.GA26809@kroah.com>
References: <20131209144712.57a50d7ed468ae8a4d57a0bf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209144712.57a50d7ed468ae8a4d57a0bf@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 02:47:12PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> fs/sysfs/file.c between commit a8b14744429f ("sysfs: give different
> locking key to regular and bin files") from the driver-core.current tree
> and commit 414985ae23c0 ("sysfs, kernfs: move file core code to
> fs/kernfs/file.c") (among others) from the driver-core tree.
> 
> I just dropped the driver-core.current tree commit as I don't see what
> needs to be done after the other changes in the driver-core tree.

Tejun said he would provide a merge fixup as we knew this was going to
be a problem :)

thanks,

greg k-h
