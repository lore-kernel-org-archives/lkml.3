Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab3HAVZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:25:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3HAVZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:25:43 -0400
Date: Fri, 2 Aug 2013 05:26:59 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: livelock avoidance in sget()
Message-ID: <20130801212659.GA14102@kroah.com>
References: <20130720193427.665E5660972@gitolite.kernel.org>
 <20130720203013.GA12294@kroah.com>
 <20130721061728.GJ4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130721061728.GJ4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 07:17:28AM +0100, Al Viro wrote:
> On Sat, Jul 20, 2013 at 01:30:13PM -0700, Greg KH wrote:
> > Hi Al,
> > 
> > Is the patch below something that we need to worry about for 3.10 and
> > older kernels?  Or does the recent changes to the vfs in 3.11-rc1 make
> > it so that this can't be hit in older kernels?
> 
> Needed since 2.6.35 or so (earlier ones have a lot more problems in that
> area and might need a similar fix if they got backports of mainline
> fixes).

Thanks, I've now queued this up.

greg k-h
