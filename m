Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3GKFX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 01:23:59 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48560 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3GKFX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 01:23:58 -0400
Date: Wed, 10 Jul 2013 22:23:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH v2 0/7] Driver core and sysfs changes for attribute groups
Message-ID: <20130711052357.GB16441@roeck-us.net>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 05:35:58PM -0700, Greg Kroah-Hartman wrote:
> Hi all,
> 
> Here's the second iteration of the patchset to add better attribute
> group support to the driver core and sysfs.
> 
> I've tested these (shocker!) and everything works fine with them (I'm
> sending this from Linus's latest kernel with these 7 on top of it.)
> 
> I'd like to send these to Linus for 3.11 unless someone objects.
> 
> Oliver, please use this series instead of the last one, it has fixes
> that Guenter pointed out that would have crashed your box at boot.
> 
> changes from v2:
> 	- actually boots
> 	- 7th patch added properly
> 	- added BUS_ATTR, CLASS_ATTR, and DRIVER_ATTR RW and RO macros
> 	  to help with converting code to use attributes properly.
> 
Looks good this time. And, yes, it does boot and work, including patch #7.
Feel free to add

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

and if you like

Tested-by: Guenter Roeck <linux@roeck-us.net>

to the series.

Thanks,
Guenter
