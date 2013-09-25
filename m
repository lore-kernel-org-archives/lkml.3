Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3IYXGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:06:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63761 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3IYXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:06:22 -0400
Date: Wed, 25 Sep 2013 16:06:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH] staging: dgrp: Convert to use device_create_with_groups
Message-ID: <20130925230616.GA5530@roeck-us.net>
References: <1377989766-7462-1-git-send-email-linux@roeck-us.net>
 <20130925230244.GA4740@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925230244.GA4740@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 04:02:44PM -0700, Greg Kroah-Hartman wrote:
> On Sat, Aug 31, 2013 at 03:56:06PM -0700, Guenter Roeck wrote:
> > Use device_create_with_groups to create sysfs attributes together with device.
> > Also create class attribute together with class registration.
> > This simplifies the code and ensures that attribute files exist when udev
> > events are generated.
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > I suspect that the 'register_with_sysfs' attribute exists to work around
> > the problem solved with this patch. It doesn't make much sense otherwise.
> > Can it be removed ?
> 
> All of these sysfs files can be removed, they shouldn't be there, as it
> looks like they are used for odd configuration things.
> 
> And a single tty driver shouldn't be a "class" at all.
> 
> sorry,
> 
No need to be sorry - not my driver, nor am I using it ;).
I am perfectly fine with you dropping this patch.

Guenter
