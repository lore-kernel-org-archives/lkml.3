Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaBEQgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:36:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaBEQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:36:34 -0500
Date: Wed, 5 Feb 2014 17:38:16 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Hannes Reinecke <hare@suse.de>
Cc: systemd-devel@lists.freedesktop.org, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [systemd-devel] [PATCH] tty: Set correct tty name in 'active'
 sysfs attribute
Message-ID: <20140205163816.GC12783@kroah.com>
References: <1391595106-86957-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391595106-86957-1-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 11:11:46AM +0100, Hannes Reinecke wrote:
> The 'active' sysfs attribute should refer to the currently
> active tty devices the console is running on, not the currently
> active console.
> The console structure doesn't refer to any device in sysfs,
> only the tty the console is running on has.
> So we need to print out the tty names in 'active', not
> the console names.
> 
> Cc: Lennart Poettering <lennart@poettering.net>
> Cc: Kay Sievers <kay@vrfy.org>
> Signed-off-by: Werner Fink <werner@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/tty/tty_io.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Would have been nice to actually cc: the tty maintainer(s) :(

scripts/get_maintainer.pl is your friend...

greg k-h
