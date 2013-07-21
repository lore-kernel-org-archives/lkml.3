Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab3GUGRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 02:17:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57602 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3GUGR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 02:17:29 -0400
Date: Sun, 21 Jul 2013 07:17:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: livelock avoidance in sget()
Message-ID: <20130721061728.GJ4165@ZenIV.linux.org.uk>
References: <20130720193427.665E5660972@gitolite.kernel.org>
 <20130720203013.GA12294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130720203013.GA12294@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 01:30:13PM -0700, Greg KH wrote:
> Hi Al,
> 
> Is the patch below something that we need to worry about for 3.10 and
> older kernels?  Or does the recent changes to the vfs in 3.11-rc1 make
> it so that this can't be hit in older kernels?

Needed since 2.6.35 or so (earlier ones have a lot more problems in that
area and might need a similar fix if they got backports of mainline
fixes).
