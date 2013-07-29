Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3G2T0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:26:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51051 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab3G2T0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:26:51 -0400
X-Sasl-enc: 4lJcHNnULe7ZkSAeTm6m2jeOAj3uu3P5+DNS5IoPGCzW 1375126010
Date: Mon, 29 Jul 2013 12:26:49 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: linux-next: manual merge of the char-misc tree with Linus' tree
Message-ID: <20130729192649.GA9191@kroah.com>
References: <20130729150129.76a9fab4023ee22c940b7920@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729150129.76a9fab4023ee22c940b7920@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 03:01:29PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in
> drivers/misc/mei/init.c between commit 99f22c4ef24c ("mei: don't have to
> clean the state on power up") from Linus' tree and commit b950ac1dabfc
> ("mei: don't get stuck in select during reset") from the char-misc tree.
> 
> (Unrelated white space changes are a pest :-()
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks, I've merged the char-misc-next branch into 3.11-rc3, so this
merge problem should no longer be there.

greg k-h
