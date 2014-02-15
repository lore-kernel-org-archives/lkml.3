Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaBORff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 12:35:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaBORfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 12:35:34 -0500
Date: Sat, 15 Feb 2014 09:37:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 3/4] mei: add mei_hbuf_acquire wrapper
Message-ID: <20140215173754.GC8056@kroah.com>
References: <1392234114-4926-1-git-send-email-tomas.winkler@intel.com>
 <1392234114-4926-4-git-send-email-tomas.winkler@intel.com>
 <20140214191338.GA423@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF721AA@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AF721AA@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 07:46:49AM +0000, Winkler, Tomas wrote:
> > 
> > This patch fails to apply:
> > 	checking file drivers/misc/mei/amthif.c
> > 	checking file drivers/misc/mei/client.c
> > 	Hunk #4 FAILED at 681.
> > 	Hunk #5 succeeded at 815 (offset -2 lines).
> > 	Hunk #6 succeeded at 848 (offset -2 lines).
> > 	1 out of 6 hunks FAILED
> > 	checking file drivers/misc/mei/hw-me.c
> > 	checking file drivers/misc/mei/hw-txe.c
> > 	checking file drivers/misc/mei/interrupt.c
> > 	checking file drivers/misc/mei/mei_dev.h
> > 	checking file drivers/misc/mei/wd.c
> 
> Did I missed something in the process? 
> This patch series has dependency on path that was destined for stable https://lkml.org/lkml/2014/2/12/389
>  as stated in 0/4 http://www.spinics.net/lists/kernel/msg1686728.html
> Quoting:
> "In order to avoid conflicts please apply after
> mei: set client's read_cb to NULL when flow control fails
> https://lkml.org/lkml/2014/2/12/389"

I never read 0/4 emails :)

Care to resend both of these patches, I'll queue them up when I merge
char-misc-linus into char-misc-next after the next -rc is out.

thanks,

greg k-h
