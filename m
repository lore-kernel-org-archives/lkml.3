Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaKCX5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:57:35 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58164 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbaKCX50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:57:26 -0500
X-Sasl-enc: 6ZhR3/OeblkmkdL8tNOP8mIhfAMmyyFu7Aj3FUJwVHfk 1415059045
Date: Mon, 3 Nov 2014 15:57:24 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20141103235724.GA31372@kroah.com>
References: <20141103132914.2a86667d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103132914.2a86667d@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 01:29:14PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/lustre/lustre/llite/file.c between commit bc281d072ba9
> ("lustre: opened file can't have negative dentry") from the vfs tree
> and commit 57303e76c225 ("staging: lustre: Fix checkpatch.pl
> spacing-related errors") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for all of these fixes, they look correct to me.

greg k-h
