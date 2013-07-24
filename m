Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3GXUeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:34:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3GXUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:34:07 -0400
Date: Wed, 24 Jul 2013 13:34:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Won Kang <wkang77@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        wonkang@gctsemi.com
Subject: Re: [PATCH v2 1/2] staging: gdm7240: adding LTE USB driver
Message-ID: <20130724203406.GA16300@kroah.com>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
 <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 03:36:17AM +0900, Won Kang wrote:
> GCT Semiconductor GDM7240 is 4G LTE chip.
> This driver supports GCT reference platform as a USB device.

I've applied this now, and fixed up the tty build warnings (which you
should have also seen.)  I'm not sure I got the tty fixes correct, can
you test the changes that I made to ensure it still works properly now?

thanks,

greg k-h
