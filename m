Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab3DAUCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:02:32 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58906 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964Ab3DAUCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:02:31 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Apr 2013 13:02:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] misc/vmw_vmci: VMWARE_VMCI depends on NET
Message-ID: <20130401200235.GA14969@roeck-us.net>
References: <1364791439-28396-1-git-send-email-linux@roeck-us.net>
 <20130401192939.GA31983@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401192939.GA31983@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 12:29:39PM -0700, Greg Kroah-Hartman wrote:
> On Sun, Mar 31, 2013 at 09:43:59PM -0700, Guenter Roeck wrote:
> > Fix:
> > 
> > ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> > ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> > 
> > Both functions are defined in the core networking code.
> 
> This is already in linux-next, thanks.
> 
Uuh ... and I submitted it. Sorry for the noise.

Any chance to apply this to 3.9-rc ? It causes a bunch of unnecessary
nightly build errors for me.

Thanks,
Guenter
