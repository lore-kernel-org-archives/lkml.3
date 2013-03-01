Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3CAB66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:58:58 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:35162 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3CAB6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:58:55 -0500
Date: Thu, 28 Feb 2013 17:59:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Erik Gilling <konkers@android.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC][PATCH 00/30] staging: Android sync driver
Message-ID: <20130301015901.GA13367@kroah.com>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:42:56PM -0800, John Stultz wrote:
> As proposed yesterday, here's the Android sync driver patches for
> staging.
> 
> I've preserved the commit history, but moved all the changes over
> to be against the staging directory (instead of drivers/base).
> 
> 
> The goal of submitting this driver to staging is to try to get
> more collaberation, as there are some similar efforts going on
> in the community with dmabuf-fences. My email from yesterday with
> more details for how I hope this goes is here:
> 	http://comments.gmane.org/gmane.linux.kernel/1448420
> 
> Erik also provided a nice background on the patch set in his
> reply yesterday, which I'll quote here:

<snip>

Mind if I put that in the 1/30 changelog body for future people to see?

Other than that, at first glance, I only have one minor question, which
I'll make in the patch itself.  Otherwise, if there are no objections,
I'll queue these up in my tree after 3.9-rc1 is out.

thanks for doing this work,

greg k-h
