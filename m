Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaHSSnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:43:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaHSSnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:43:13 -0400
Date: Tue, 19 Aug 2014 13:38:25 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com, max@vozeler.com
Subject: Re: [PATCH 2/3] usbip: move usbip kernel code out of staging
Message-ID: <20140819183825.GA2477@kroah.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
 <1407388229-31807-4-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407388229-31807-4-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 08:10:28AM +0300, Valentina Manea wrote:
> At this point, USB/IP kernel code is fully functional
> and can be moved out of staging.
> 
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>

This patch moves the code, but now it's "gone" from the build system as
it is not hooked up and can not be built at all.

So while I really wanted to apply this series right now, I can't, as
this is a regression (working driver -> no driver).

Can you redo this series and actually add the driver to the build, as
well as adding a MAINTAINERS entry so that I can apply it all?  I'd like
to get this into 3.17-rc2 if possible, before things start to change
again.

thanks,

greg k-h
