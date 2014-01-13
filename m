Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaAMXuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:50:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaAMXuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:50:06 -0500
Date: Mon, 13 Jan 2014 15:50:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <cyborg101010@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DAS1800: Fixing foo * bar should be foo *bar
Message-ID: <20140113235042.GA22328@kroah.com>
References: <1389655155-20071-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389655155-20071-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:19:15PM +0000, Joe Borg wrote:
> Fixed an error flagged by checkpatch.pl, 'foo * bar should be foo
> *bar' in the parameters of function munge_data().

Ok, real minor nits here, but I'd like you to make them for future
patches as it makes my life easier, and I don't like to edit patches by
hand, as I don't scale very well.

Your subject should be:
	[PATCH] staging: comedi: das1800: fix for * bar to be foo *bar

you need to add the driver subsystem, and specific area and driver.  And
no kernel drivers are ALL CAPS, so that should never be used.

I've taken this patch as-is, but in the future please try to do this.

Oh, one more thing:

> Signed-off-by Joe Borg <cyborg101010@gmail.com>

You forgot a ':' here :)

thanks,

greg k-h
