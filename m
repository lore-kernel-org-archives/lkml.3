Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaFLOK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:10:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbaFLOK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:10:56 -0400
Date: Thu, 12 Jun 2014 07:10:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wahib Faizi <wahibfaizi@gmail.com>
Cc: Valentina Manea <valentina.manea.m@gmail.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c: fix coding style
Message-ID: <20140612141050.GA7203@kroah.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
 <1402569338-5709-2-git-send-email-wahibfaizi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402569338-5709-2-git-send-email-wahibfaizi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 02:35:38PM +0400, Wahib Faizi wrote:
> Fix coding style issues detected by checkpatch.pl:
> 1. do not use assignment in if condition
> 2. line over 80 characters

You are doing two different things here, so please break it up into two
different patches.  Can you please do this and resend?

thanks,

greg k-h
