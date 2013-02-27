Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506Ab3B0RhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:37:17 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:62197 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760263Ab3B0RhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:37:15 -0500
Date: Wed, 27 Feb 2013 09:37:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [ 79/86] USB: ehci-omap: Dont free gpios that we didnt request
Message-ID: <20130227173712.GA10652@kroah.com>
References: <20130226235912.881663118@linuxfoundation.org>
 <20130226235921.105248169@linuxfoundation.org>
 <512DBB46.1080609@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512DBB46.1080609@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 09:52:38AM +0200, Roger Quadros wrote:
> Hi Greg,
> 
> On 02/27/2013 02:08 AM, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Roger Quadros <rogerq@ti.com>
> > 
> > commit 428525f97153505e83983460a8d08a3210aa6b8a upstream.
> > 
> > This driver does not request any gpios so don't free them.
> > Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
> > with ehci-omap in use.
> 
> Please drop this patch from 3.4-stable.
> 
> In 3.4, the driver requests the gpios in probe() so they must be freed
> in remove() and this patch should not be applied. Thanks.

Thanks for letting me know, now dropped.

greg k-h
