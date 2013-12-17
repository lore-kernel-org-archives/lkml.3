Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3LQIpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:45:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3LQIpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:45:06 -0500
Date: Tue, 17 Dec 2013 09:45:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo in DEVTMPFS_MOUNT help text
In-Reply-To: <52AF9F68.8050300@elopez.com.ar>
Message-ID: <alpine.LNX.2.00.1312170943001.28730@pobox.suse.cz>
References: <1385992779-15544-1-git-send-email-emilio@elopez.com.ar> <52AF9F68.8050300@elopez.com.ar>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013, Emilio López wrote:

> > rootfs was missing its f.
> > 
> > Signed-off-by: Emilio López <emilio@elopez.com.ar>
> > ---
> >   drivers/base/Kconfig | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> > index e373671..ec36e77 100644
> > --- a/drivers/base/Kconfig
> > +++ b/drivers/base/Kconfig
> > @@ -49,7 +49,7 @@ config DEVTMPFS_MOUNT
> >   	  with the commandline parameter: devtmpfs.mount=0|1.
> >   	  This option does not affect initramfs based booting, here
> >   	  the devtmpfs filesystem always needs to be mounted manually
> > -	  after the roots is mounted.
> > +	  after the rootfs is mounted.
> >   	  With this option enabled, it allows to bring up a system in
> >   	  rescue mode with init=/bin/sh, even when the /dev directory
> >   	  on the rootfs is completely empty.
> > 
> 
> ping

Hi Emilio,

patience is a virtue, especially for not urgent patches like this.

Don't worry, it's in my queue of patches to be processed, it hasn't been 
lost.

Thanks,

-- 
Jiri Kosina
SUSE Labs
