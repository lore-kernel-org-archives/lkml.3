Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaKFCT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:19:58 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47768 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbaKFCTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:19:55 -0500
X-Sasl-enc: OSKN0gFhOBnxTgLnMpssjcj2fJM9dcjxb05m+WfgZJMz 1415240394
Date: Wed, 5 Nov 2014 18:19:53 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amber Thrall <amber.rose.thrall@gmail.com>,
        Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20141106021953.GC17253@kroah.com>
References: <20141105152911.69bd1a14@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105152911.69bd1a14@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 03:29:11PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/media/lirc/lirc_imon.c between commit f3a75505ab5f
> ("[media] Staging: media: lirc: cleaned up packet dump in 2 files")
> from the v4l-dvb tree and commit 732ba199ab07 ("staging: media: lirc:
> lirc_imon.c: replace printk by dev_dbg") from the staging tree.
> 
> I fixed it up (the staging tree patch was not complete, so I did the
> below) and can carry the fix as necessary (no action is required).

Thanks for all 3 of these, they look fine.

greg k-h
