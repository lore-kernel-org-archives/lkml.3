Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaCADuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 22:50:14 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62243 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaCADuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:50:12 -0500
Date: Fri, 28 Feb 2014 00:30:04 -0800
From: Masood Mehmood <ody.guru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:tidspbridge: Fixing coding style
Message-ID: <20140228083003.GA1944@localhost.localdomain>
References: <20140301021552.GB32665@localhost.localdomain>
 <20140301030156.GA17472@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140301030156.GA17472@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Feb 28, 2014 at 07:01:56PM -0800, Greg Kroah-Hartman wrote:
> On Fri, Feb 28, 2014 at 06:15:52PM -0800, Masood Mehmood wrote:
> > 
> 
> > 
> > Fixing some basic coding style issues.
> 
> Which issues did you fix?  Please be more specific.  Did you fix them
> for the whole driver, or just a specific file?

- Unnecessary line break and space.
- and some * adjusted to the data name
- Removed braces for single statement if conditions.

I just realized, other files of the same driver also need some style fixes.
I'll send another patch with reset of the files included.

> 
> And what's with the odd multiple attachments?
Sorry, new to mutt.

> 
> thanks,
> 
> greg k-h

Thanks,
Masood

