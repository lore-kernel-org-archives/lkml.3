Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaLOQeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:34:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaLOQeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:34:20 -0500
Date: Mon, 15 Dec 2014 08:34:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.18 15/19] move d_rcu from overlapping d_child to
 overlapping d_alias
Message-ID: <20141215163419.GA1351@kroah.com>
References: <20141214201823.543296369@linuxfoundation.org>
 <20141214201823.978185416@linuxfoundation.org>
 <20141215154650.GA6542@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215154650.GA6542@vader>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:46:50AM -0500, Josh Boyer wrote:
> On Sun, Dec 14, 2014 at 12:21:26PM -0800, Greg Kroah-Hartman wrote:
> >3.18-stable review patch.  If anyone has any objections, please let me know.
> >
> >------------------
> >
> >From: Al Viro <viro@zeniv.linux.org.uk>
> >
> >commit 946e51f2bf37f1656916eb75bd0742ba33983c28 upstream.
> >
> >Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> >Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I noticed you don't have this (and the child commit) queued for 3.17.y.

That is because:

> The backport wasn't exactly straight-forward because of the d_external
> stuff, but I took a swing at it.  After that, the other commit was a
> quick cherry-pick.

It wasn't a "simple" backport, and I didn't have the time.  I'm also
going to drop 3.17 real-soon-now.

> Al, does the below look correct for a backport on top of 3.17.6?  It
> builds, but I haven't tested it yet.

Testing would be great to do :)

thanks,

greg k-h
