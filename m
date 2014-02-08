Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaBHAA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:00:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaBHAA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:00:56 -0500
Date: Fri, 7 Feb 2014 16:02:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: Linux 3.13.2
Message-ID: <20140208000206.GA17796@kroah.com>
References: <20140206200134.GA2213@kroah.com>
 <1391815794.1155.68.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391815794.1155.68.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 03:29:54PM -0800, Nicholas A. Bellinger wrote:
> On Thu, 2014-02-06 at 12:01 -0800, Greg KH wrote:
> > I'm announcing the release of the 3.13.2 kernel.
> > 
> > All users of the 3.13 kernel series must upgrade.
> > 
> > The updated 3.13.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.13.y
> > and can be browsed at the normal kernel.org git web browser:
> > 	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Hi Greg,
> 
> I noticed that the following two target upstream patches in v3.14-rc1
> did not make it into v3.13.y or stable-queue.git:
> 
> commit 6f6b5d1ec56acdeab0503d2b823f6f88a0af493e
> Author: Kent Overstreet <kmo@daterainc.com>
> Date:   Sun Jan 19 08:26:37 2014 +0000
> 
>     percpu_ida: Make percpu_ida_alloc + callers accept task state bitmask
> 
> commit 555b270e25b0279b98083518a85f4b1da144a181
> Author: Nicholas Bellinger <nab@linux-iscsi.org>
> Date:   Mon Jan 20 03:36:24 2014 +0000
> 
>     iscsi-target: Fix connection reset hang with percpu_ida_alloc
> 
> These two patches have been respun for v3.13.y code here:
> 
> http://www.spinics.net/lists/target-devel/msg06191.html
> http://www.spinics.net/lists/target-devel/msg06192.html
> 
> Please apply for v3.13.y ASAP.

They are in my queue, I have a few hundred other patches to dig through
as well.  Don't worry, they aren't lost...

Same goes for 3.12 and the other patches you have resent me, please be
patient.

thanks,

greg k-h
