Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3BRTRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:17:25 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:43524 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab3BRTRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:17:23 -0500
Date: Mon, 18 Feb 2013 11:17:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BONUS PATCH 2/2] base: core: WARN() about bogus permissions on
 device attributes
Message-ID: <20130218191719.GB19724@kroah.com>
References: <1361214544-14403-1-git-send-email-balbi@ti.com>
 <1361214544-14403-2-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361214544-14403-2-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 09:09:04PM +0200, Felipe Balbi wrote:
> Whenever a struct device_attribute is registered
> with mismatched permissions - read permission without
> a show routine or write permission without store
> routine - we will issue a big warning so we catch
> those early enough.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> 
> This is completely untested. I have only compile tested
> to make sure I'm not breaking anything.
> 
> Greg, do you think this would be nice to have ? I could
> fire up kvm tomorrow and run on a few of my OMAP-based
> boards to make sure it works as expected.

Looks good, but you better fix up all of the big offenders that this
points out, before I apply it, otherwise we will get a ton of bug
reports :)

thanks,

greg k-h
