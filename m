Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3KOWK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:10:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3KOWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:10:53 -0500
Date: Sat, 16 Nov 2013 07:10:57 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, len.brown@intel.com, pavel@ucw.cz,
        rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH] power: Replace printks with pr_* routines
Message-ID: <20131115221057.GA16530@kroah.com>
References: <1384531806-11500-1-git-send-email-shuah.kh@samsung.com>
 <20131115211922.GB14410@kroah.com>
 <1384551981.18739.36.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384551981.18739.36.camel@joe-AO722>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 01:46:21PM -0800, Joe Perches wrote:
> On Sat, 2013-11-16 at 06:19 +0900, Greg KH wrote:
> > On Fri, Nov 15, 2013 at 09:10:06AM -0700, Shuah Khan wrote:
> > > Replaced printks with pr_* routines. dev_* routines could have been used,
> > > but chose to use pr_* to avoid breaking scripts that might be relying on
> > > a specific text.
> > 
> > I'd really like to switch to dev_* instead, even changing to pr_* should
> > change the output prefix (if it's set for this file, odds are it isn't
> > though...)
> 
> It's not.
> 
> Something like this?
> 
> Pass a struct device * through to the PM
> suspend logging routines.  Use dev_<level>
> instead of printks.

That looks good to me, Shuah, does it work for you?

greg k-h
