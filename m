Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaGPUxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:53:09 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35692 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbaGPUxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:53:06 -0400
X-Sasl-enc: PAifJqTB8rrX0APheWKUIB/XnBncT99hXkIGNr1Sxr4H 1405543984
Date: Wed, 16 Jul 2014 13:52:39 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb
 tree
Message-ID: <20140716205239.GB14387@kroah.com>
References: <20140716164654.67300e1a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716164654.67300e1a@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 04:46:54PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/media/sn9c102/Kconfig between commit c0e11a2a24db
> ("[media] sn9c102: remove deprecated driver") from the v4l-dvb tree and
> commit cfa880069d09 ("staging: sn9c102 depends on USB") from the
> staging tree.
> 
> I fixed it up (I just removed the file) and can carry the fix as
> necessary (no action is required).

Thanks, lots of staging drivers are getting deleted here, which is a
good thing :)

greg k-h
