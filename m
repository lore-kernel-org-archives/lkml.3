Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaCLBsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:48:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34663 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539AbaCLBs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:48:27 -0400
X-Sasl-enc: qqK0d8JKV1/bcUxcYW92renDQwThrpJI+nO8sy9unSM3 1394588907
Date: Tue, 11 Mar 2014 18:49:14 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@kernel.org>
Cc: Salva =?iso-8859-1?Q?Peir=F3?= <speiro@ai2.upv.es>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging tree with the  tree
Message-ID: <20140312014914.GB10106@kroah.com>
References: <20140312013259.d374b64c0655e98612d880b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312013259.d374b64c0655e98612d880b3@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:32:59AM +0000, Mark Brown wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in drivers/staging/cxt1e1/linux.c between commit 084b6e7765b95 ("staging/cxt1e1/linux.c: Correct arbitrary memory write in c4_ioctl()") from Linus' tree and commit aa562fa70931d ("staging: cxt1e1: Fix no spaces at the start of a line in linux.c") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Known issue, was reported previously and fixed up in linux-next and I
will handle it when I merge my trees together...

thanks,

greg k-h
