Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3K0DTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:19:47 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46899 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459Ab3K0DTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:19:45 -0500
X-Sasl-enc: su2MfZQs4TiuCQiH4QHLwcuX3gxNG943usVvwH+aVEx5 1385522381
Date: Tue, 26 Nov 2013 19:20:28 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20131127032028.GA22475@kroah.com>
References: <20131127130144.8db67b95b9c1a0141ab58a4a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127130144.8db67b95b9c1a0141ab58a4a@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 01:01:44PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got conflicts in
> drivers/staging/tidspbridge/pmgr/cmm.c,
> drivers/staging/tidspbridge/pmgr/dbll.c,
> drivers/staging/tidspbridge/pmgr/dev.c,
> drivers/staging/tidspbridge/pmgr/dmm.c and
> drivers/staging/tidspbridge/pmgr/dspapi.c between commit cb45065428b7
> ("staging: delete tidspbridge driver") from the staging.current tree and
> various commits from the staging tree.
> 
> I just removed the files and can carry the fix as necessary (no action
> is required).

Thanks, that is the correct thing.

greg k-h
