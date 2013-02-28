Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3B1CcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 21:32:10 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54463 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3B1CcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 21:32:06 -0500
Date: Wed, 27 Feb 2013 18:32:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Erik Gilling <konkers@android.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFD] Proposal for merging Android sync driver in staging
Message-ID: <20130228023207.GB4042@kroah.com>
References: <512EBD80.8070101@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512EBD80.8070101@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 06:14:24PM -0800, John Stultz wrote:
> I'd like to get a discussion going about submitting the Android sync
> driver to staging.
> 
> I know there is currently some very similar work going on with the
> dmabuf-fences, and rather then both approaches being worked out
> individually on their own, I suspect there could be better
> collaboration around this effort.
> 
> So my proposal is that we merge the Android sync driver into staging.
> 
> In my mind, this has the following benefits:
> 1) It allows other drivers that depend on the sync interface to also
> be submitted to staging, rather then forcing those drivers to be
> hidden away in various out of tree git repos, location unknown.
> 
> 2) It would provide a baseline view to the upstream community of the
> interface Android is using, providing  a real-world, active use case
> of the functionality.
> 
> Once the sync driver is in staging, if the dmabuf-fences work is
> fully sufficient to replace the Android sync driver, we should be
> able to whittle down the sync driver until its just a interface shim
> (and at which point efforts can be made to convert Android userland
> over to dmabuf-fences).

Sounds like a good plan to me.

> I've gone through the Android tree and reworked the sync driver to
> live in staging, while still preserving the full patch
> history/authorship. You can checkout the reworked patch queue here:
>  http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/sync-staging

I can't really look at a git tree at the moment, but will always be glad
to review patches.  Feel free to send them on and we can look at them
then :)

thanks,

greg k-h
