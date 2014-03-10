Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaCJQzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:55:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaCJQzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:55:12 -0400
Date: Mon, 10 Mar 2014 09:51:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com
Subject: Re: [PATCH 1/2] usbcore: rename struct dev_state to struct
 usb_dev_state
Message-ID: <20140310165150.GB12687@kroah.com>
References: <1394440601-13573-1-git-send-email-valentina.manea.m@gmail.com>
 <1394440601-13573-2-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394440601-13573-2-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:36:40AM +0200, Valentina Manea wrote:
> Since it is needed outside usbcore and exposed in include/linux/usb.h,
> it conflicts with enum dev_state in rt2x00 wireless driver.
> 
> Mark it as usb specific to avoid conflicts in the future.
> 
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>

With this patch, you break the usbip code, you can never have a patch
that breaks the build :(

I'll merge both of these together to prevent this from happening.

thanks,

greg k-h
