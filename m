Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab3CTTWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:22:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55130 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069Ab3CTTWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:22:16 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 20 Mar 2013 12:22:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging/iio: iio_hwmon: Use device tree node name for
 hwmon name attribute
Message-ID: <20130320192216.GA966@roeck-us.net>
References: <1363794751-31977-1-git-send-email-linux@roeck-us.net>
 <5149FFC5.3040504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5149FFC5.3040504@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 06:28:21PM +0000, Jonathan Cameron wrote:
> On 03/20/2013 03:52 PM, Guenter Roeck wrote:
> > So far, all instances of iio_hwmon set their hwmon name attribute
> > to "iio_hwmon", which is not very descriptive. Set it to the device tree
> > node name if available, and only revert to iio_hwmon otherwise.
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > 
> > Jonathan, can we move this driver out of staging ?
> > I would like to see it in 3.10 if possible.
> 
> Certainly. Now you've cleaned it up nicely it's ready
> to go as far as I am concerned.  I'll put together a patch
> on top of this sometime in the next couple of days and
> post to the relevant lists etc and if no one shouts I'll
> send it in a pull request to Greg around next weekend....
> 

Sounds good.

> Thanks for all your hard work!
> 
My pleasure.

Thanks,
Guenter
