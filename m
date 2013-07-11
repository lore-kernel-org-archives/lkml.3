Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3GKG1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:27:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab3GKG1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:27:34 -0400
Date: Wed, 10 Jul 2013 23:28:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH v2 0/7] Driver core and sysfs changes for attribute groups
Message-ID: <20130711062834.GB15254@kroah.com>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
 <20130711052357.GB16441@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711052357.GB16441@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 10:23:57PM -0700, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 05:35:58PM -0700, Greg Kroah-Hartman wrote:
> > Hi all,
> > 
> > Here's the second iteration of the patchset to add better attribute
> > group support to the driver core and sysfs.
> > 
> > I've tested these (shocker!) and everything works fine with them (I'm
> > sending this from Linus's latest kernel with these 7 on top of it.)
> > 
> > I'd like to send these to Linus for 3.11 unless someone objects.
> > 
> > Oliver, please use this series instead of the last one, it has fixes
> > that Guenter pointed out that would have crashed your box at boot.
> > 
> > changes from v2:
> > 	- actually boots
> > 	- 7th patch added properly
> > 	- added BUS_ATTR, CLASS_ATTR, and DRIVER_ATTR RW and RO macros
> > 	  to help with converting code to use attributes properly.
> > 
> Looks good this time. And, yes, it does boot and work, including patch #7.
> Feel free to add
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> 
> and if you like
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> to the series.

Thanks for the testing and review, I'll add this when I commit them
sometime next week.

greg k-h
