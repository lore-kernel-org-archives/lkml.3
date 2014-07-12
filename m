Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaGLUTt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:19:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaGLUTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:19:46 -0400
Date: Sat, 12 Jul 2014 13:24:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: swetland@google.com, daniel@ffwll.ch, maarten.lankhorst@canonical.com,
        john.stultz@linaro.org, sumit.semwal@linaro.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: android: Cleanup style issues
Message-ID: <20140712202415.GA10041@kroah.com>
References: <1405194956-4590-1-git-send-email-peter.senna@gmail.com>
 <20140712202310.GA9919@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712202310.GA9919@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 01:23:10PM -0700, Greg KH wrote:
> On Sat, Jul 12, 2014 at 09:55:56PM +0200, Peter Senna Tschudin wrote:
> > This patch fixes the following checkpatch warnings:
> >  - Remove else after return
> >  - Add space after declaration
> > 
> > Tested by compilation only.
> > 
> > Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> > ---
> >  drivers/staging/android/sync_debug.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> This file is no longer in my kernel tree, what tree did you make it
> against?
> 
> Please create staging patches against the staging-next branch of the
> staging.git tree on git.kernel.org so that I can apply them.

Ah, nevermind, things moved around here, I figured this out, sorry for
the noise...

greg k-h
