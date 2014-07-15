Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaGORiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:38:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbaGORiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:38:22 -0400
Date: Tue, 15 Jul 2014 10:42:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 95/95] Staging: commedi: 8253.h: style issue fixed
Message-ID: <20140715174255.GA5290@kroah.com>
References: <1405443875-15807-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405443875-15807-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 95/95?  Really?  Where are the other 94 patches in this series?

:(

Please look at what you are doing here, does it make sense?

On Tue, Jul 15, 2014 at 08:04:35PM +0300, Sam Asadi wrote:
> a revision to the file that previously had several style issues.
> It's clean now.

What does this mean?  What did you do in this changeset?  Describe _why_
you made the change, not the result of what happened _after_ this patch
is applied.

Please step back, take a day or two to regroup, and revisit what you are
trying to do here.  You are not sending out patches correctly at all.
Please read some tutorials on how to do this properly (try
kernelnewbies.org) and then do a dry-run by sending the patches to
yourself.

After that looks correct, then consider sending them to the kernel
developers.

But again, wait, don't rush, there's no deadline here.

greg k-h
