Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaAIQng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:43:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaAIQn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:43:27 -0500
Date: Thu, 9 Jan 2014 08:43:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: ly80toro@cip.cs.fau.de, standby24x7@gmail.com, alan@linux.intel.com,
        ihadzic@research.bell-labs.com, anthony.foiani@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, andy.grover@gmail.com,
        firefly@lists.rosedu.org
Subject: Re: [PATCH] staging: usbip: userspace: add support for viewing
 imported devices
Message-ID: <20140109164349.GA8361@kroah.com>
References: <1389121556-7465-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389121556-7465-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 09:05:56PM +0200, Valentina Manea wrote:
> As of Matt Mooney's major refactoring in 2011, usbip port
> option was left out. Add support for this option in
> a manner similar to the old implementation.
> 
> Sample output:
> 
> Imported USB devices
> ====================
> Port 00: <Port in Use> at Full Speed(12Mbps)
>        unknown vendor : unknown product (1687:6211)
>        2-1 -> usbip://192.168.122.152:3240/1-1
>            -> remote bus/dev 001/002
> 
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
> Reviewed-by: Ilija Hadzic <ihadzic@research.bell-labs.com>

This is a resend of v3, right?  Please be more specific when sending
multiple versions of a patch so that I know which one I should take.

> Resubmitting this patch as I still didn't get any reply from Greg
> after 2 weeks.

Greg was on vacation for 2 weeks :)

thanks,

greg k-h
