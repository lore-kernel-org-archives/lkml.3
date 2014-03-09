Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaCIBVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 20:21:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaCIBVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 20:21:40 -0500
Date: Sat, 8 Mar 2014 17:22:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Conrad Meyer <cemeyer@uw.edu>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Updated: [PATCH] Staging: comedi: Fix 80-char line limit style
 issue in addi_apci_1500.c
Message-ID: <20140309012216.GA13522@kroah.com>
References: <20140308154724.57a1d53d@m>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140308154724.57a1d53d@m>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 03:47:24PM -0500, Conrad Meyer wrote:
> Rename some very long functions in addi-data/hwdrv_apci1500.c.
> 
> Signed-off-by: Conrad Meyer <cse.cem@gmail.com>

When you update a patch, it's better to have the subject be:
	[PATCH v2] Staging: ....

Otherwise what are you going to do for the update to the update?  :)

Don't worry about it this time, I'll take this for now.

thanks,

greg k-h
