Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaHAHid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:38:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57200 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbaHAHic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:38:32 -0400
X-Sasl-enc: 5ByfWGPaAVISY/iKxKOBnM168skCF3bRvCZ9nYPUM7Ig 1406878710
Date: Fri, 1 Aug 2014 00:38:00 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Kristina =?utf-8?Q?Mart=C5=A1enko?= 
	<kristina.martsenko@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the  tree
Message-ID: <20140801073800.GB31866@kroah.com>
References: <20140801162142.24086152@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801162142.24086152@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:21:42PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> MAINTAINERS between commit 7eea35fe3df8 ("[media] MAINTAINERS: Update
> go7007 pattern") from the v4l-dvb tree and commit 0d317b91d6d8
> ("staging: frontier: remove driver") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks.

greg k-h
