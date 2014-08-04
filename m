Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaHDVs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:48:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHDVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:48:24 -0400
Date: Mon, 4 Aug 2014 14:48:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Kiran Padwal <kiran.padwal@smartplayin.com>, davidb@codeaurora.org,
        dwalker@fifo99.com, bryanh@codeaurora.org, sboyd@codeaurora.org,
        jslaby@suse.cz, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm: fix checkpatch warnings
Message-ID: <20140804214823.GA19238@kroah.com>
References: <1407162046-29729-1-git-send-email-kiran.padwal@smartplayin.com>
 <53DFFE2A.7010002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DFFE2A.7010002@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 02:42:02PM -0700, Frank Rowand wrote:
> On 8/4/2014 7:20 AM, Kiran Padwal wrote:
> > This patch fixes the following checkpatch.pl warning:
> > 
> > WARNING: braces {} are not necessary for any arm of this statement
> > 
> > WARNING: Missing a blank line after declarations
> > 
> > WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> > 
> > WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> > 
> > WARNING: else is not generally useful after a break or return
> > 
> > WARNING: void function return statements are not generally useful
> > 
> > Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> > ---
> >  drivers/tty/serial/msm_serial.c |   26 +++++++++++---------------
> >  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> Kiran,
> 
> I have a series of fix patches against this file that is going to collide
> with your cleanups.  Would you mind waiting until after I send my patches
> to do your clean up?

It's a first-come-first served, never ask someone to wait for you to
send your patches, you can't 'lock' a file in the kernel from changes
from others, that way is the death of a project.

So no, Kiran, don't wait :)

thanks,

greg k-h
