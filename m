Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3GJWZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:25:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3GJWZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:25:00 -0400
Date: Wed, 10 Jul 2013 15:24:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH 7/6] driver core: add default groups to struct class
Message-ID: <20130710222459.GA3818@kroah.com>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <20130710220531.GA4210@kroah.com>
 <20130710221812.GA22366@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710221812.GA22366@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 03:18:12PM -0700, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 03:05:31PM -0700, Greg Kroah-Hartman wrote:
> > 
> > We should be using groups, not attribute lists, for classes to allow
> > subdirectories, and soon, binary files.  Groups are just more flexible
> > overall, so add them.
> > 
> > The dev_attrs list will go away after all in-kernel users are converted
> > to use dev_groups.
> > 
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Nice one ... that solves my problem.

Thanks, I'll work on 'struct bus_type' next, moving that to only use
groups, but that's not as important from what I can tell, busses don't
seem to abuse sysfs as bad as drivers and devices do :)

thanks,

greg k-h
