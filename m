Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaCIGuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 01:50:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaCIGuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 01:50:23 -0500
Date: Sat, 8 Mar 2014 22:50:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        tobias.polzer@fau.de, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, dominik.paulus@fau.de, andy.grover@gmail.com,
        ihadzic@research.bell-labs.com
Subject: Re: [PATCH 00/18] Resend of usbip-utils migration patches and
 various other fixes
Message-ID: <20140309065059.GA10398@kroah.com>
References: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 02:53:18PM +0200, Valentina Manea wrote:
> This is a resend of the patches sent a few days ago, including
> the migration of USB/IP userspace side to use libudev instead
> of libsysfs and various other fixes, all ordered in a big patch
> series.

Very nice work, thanks so much for doing all of this, it looks great.

Now applied to my tree, you should have gotten the emails about it
already.

thanks,

greg k-h
