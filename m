Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3DFSSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 14:18:41 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:43674 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab3DFSSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 14:18:39 -0400
Date: Sat, 6 Apr 2013 11:18:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Lucas <canolucas@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.8.6
Message-ID: <20130406181836.GA2406@kroah.com>
References: <20130405174012.GA28836@kroah.com>
 <51606512.8030703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51606512.8030703@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 03:10:26PM -0300, Lucas wrote:
> On 05/04/13 14:40, Greg KH wrote:
> >I'm announcing the release of the 3.8.6 kernel.
> >
> >All users of the 3.8 kernel series must upgrade.
> >
> >The updated 3.8.y git tree can be found at:
> >	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.8.y
> >and can be browsed at the normal kernel.org git web browser:
> >	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Hi Greg, I have an issue with a Lenovo T60's Notebook, which has an
> Intel VGA card.
> 
> [lucas@tux ~]$ lspci | grep "VGA"
> 00:02.0 VGA compatible controller: Intel Corporation Mobile
> 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev
> 03)
> 
> The screen turns black whenever X is executed, due to the following bug:
> 
> https://bugs.freedesktop.org/show_bug.cgi?id=57365
> 
> https://bugs.archlinux.org/task/33062
> 
> Those sites havethe error output that is generated from X attempts
> to start. Nonetheless, the causes of this issue have already been
> figured:
> 
> According to comment #32 in the freedesktop site (
> https://bugs.freedesktop.org/show_bug.cgi?id=57365#c32 ), the fix
> has been introduced in the 3.9 series.
> 
> Believe it or not, the last stable release in which X is able to
> start is 3.6.11. The whole 3.7 and 3.8 series together were unable
> to tackle this issue down. Seems that Intel is not doing its
> homework here :(
> 
> My question is:
> 
> Knowing that the following patches solve the issue, can they be
> backported and included in the next release of 3.8 ?
> 
> Thank you very much,
> Lucas
> 
> 
> commit 24a1f16de97c4cf0029d9acd04be06db32208726
> Author: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Date:   Fri Feb 8 16:35:37 2013 +0200
> 
>     drm/i915: disable shared panel fitter for pipe
> 
> 
> commit 9d6d9f19e8146fa24903cb561e204a22232740e3
> Author: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Date:   Fri Feb 8 16:35:38 2013 +0200
> 
>     drm/i915: clean up panel fitter handling in lvds

Sure, can you cc: the authors of those patches, and anyone who
signed-off on them in order to get their approval as well?

thanks,

greg k-h
