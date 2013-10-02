Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3JBVZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:25:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3JBVZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:25:08 -0400
Date: Wed, 2 Oct 2013 14:24:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sven Joachim <svenjoac@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Imre Deak <imre.deak@intel.com>,
        "cancan,feng" <cancan.feng@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [ 005/117] drm/i915: make user mode sync polarity setting
 explicit
Message-ID: <20131002212452.GA12120@kroah.com>
References: <20130925001740.833541979@linuxfoundation.org>
 <20130925001741.446963782@linuxfoundation.org>
 <87r4c3vavb.fsf@turtle.gmx.de>
 <CAKMK7uHGVcEZt16aDgoUCfyRMtcw76geDtOvpd_qzMZ2+a7U_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHGVcEZt16aDgoUCfyRMtcw76geDtOvpd_qzMZ2+a7U_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:11:53PM +0200, Daniel Vetter wrote:
> On Wed, Oct 2, 2013 at 7:30 PM, Sven Joachim <svenjoac@gmx.de> wrote:
> > See also https://bugs.freedesktop.org/show_bug.cgi?id=65442#c16.
> 
> Oh dear, somehow I've thought the -fixes pull request I've sent with
> the fix for this has a cc: stable, but that must have been lost
> somewhere.
> 
> Greg, can you please queue up
> 
> commit 1062b81598bc00e2f6620e6f3788f8f8df2f01e7
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Tue Sep 10 11:44:30 2013 +0200
> 
>     drm/i915/tv: clear adjusted_mode.flags
> 
> for stable kernels? Right now we seem to get about one dupe per day of
> this report ;-)
> 
> /me wondered why they kept on coming up ...

Now queued up, thanks for letting me know.

greg k-h
