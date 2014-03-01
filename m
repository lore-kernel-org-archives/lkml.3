Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaCAEJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:09:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaCAEJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:09:29 -0500
Date: Fri, 28 Feb 2014 20:09:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Masood Mehmood <ody.guru@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:tidspbridge: Fixing coding style
Message-ID: <20140301040934.GA6169@kroah.com>
References: <20140301021552.GB32665@localhost.localdomain>
 <20140301030156.GA17472@kroah.com>
 <20140228083003.GA1944@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228083003.GA1944@localhost.localdomain>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:30:04AM -0800, Masood Mehmood wrote:
> 
> On Fri, Feb 28, 2014 at 07:01:56PM -0800, Greg Kroah-Hartman wrote:
> > On Fri, Feb 28, 2014 at 06:15:52PM -0800, Masood Mehmood wrote:
> > > 
> > 
> > > 
> > > Fixing some basic coding style issues.
> > 
> > Which issues did you fix?  Please be more specific.  Did you fix them
> > for the whole driver, or just a specific file?
> 
> - Unnecessary line break and space.
> - and some * adjusted to the data name
> - Removed braces for single statement if conditions.

Great, can you put that in the patch itself?

As it's small, they all can be in the same patch, but normally we only
want one patch per "type" of change.  For this case, if it was lots of
changes, you would break it up into different patches.

> I just realized, other files of the same driver also need some style fixes.
> I'll send another patch with reset of the files included.

Watch out, now you might want to send multiple patches, based on the
above "one thing per patch" rule.

thanks,

greg k-h
