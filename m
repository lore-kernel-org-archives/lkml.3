Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3DAUL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:11:56 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38112 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab3DAULy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:11:54 -0400
Date: Mon, 1 Apr 2013 13:11:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] misc/vmw_vmci: VMWARE_VMCI depends on NET
Message-ID: <20130401201152.GA29283@kroah.com>
References: <1364791439-28396-1-git-send-email-linux@roeck-us.net>
 <20130401192939.GA31983@kroah.com>
 <20130401200235.GA14969@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401200235.GA14969@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 01:02:35PM -0700, Guenter Roeck wrote:
> On Mon, Apr 01, 2013 at 12:29:39PM -0700, Greg Kroah-Hartman wrote:
> > On Sun, Mar 31, 2013 at 09:43:59PM -0700, Guenter Roeck wrote:
> > > Fix:
> > > 
> > > ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> > > ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> > > 
> > > Both functions are defined in the core networking code.
> > 
> > This is already in linux-next, thanks.
> > 
> Uuh ... and I submitted it. Sorry for the noise.
> 
> Any chance to apply this to 3.9-rc ? It causes a bunch of unnecessary
> nightly build errors for me.

As it's a configuration that no "real" user would ever hit, it's not
really 3.9 material, sorry.

greg k0h
