Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaCAAeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:34:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaCAAeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:34:11 -0500
Date: Fri, 28 Feb 2014 16:35:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Ray Strode <halfline@gmail.com>, Kay Sievers <kay@vrfy.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>
Subject: Re: [PATCH] tty: Add sysfs symlink for console name->tty device
Message-ID: <20140301003549.GB31852@kroah.com>
References: <1393425651-7374-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393425651-7374-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 09:40:51AM -0500, Peter Hurley wrote:
> Enable a user-space process to discover the underlying tty device
> for a console, if one exists, and when the tty device is later
> created or destroyed.

What userspace code has been tested with this change?

> Add sysfs symlinks for registered consoles to their respective
> devices in [sys/class,sys/devices/virtual]/tty/console.
> Scan consoles at tty device (un)registration to handle deferred
> console<->device (un)binding.

I don't understand, what does userspace now look like in sysfs?  Do we
need Documentation/ABI/ updates here?

And David has fixed up his original patch, which doesn't break plymouth,
and I'll be taking that, so I don't see why this patch is needed.

thanks,

greg k-h
