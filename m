Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3AKNh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:37:29 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33221 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3AKNh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:37:27 -0500
Date: Fri, 11 Jan 2013 05:38:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 004/123] b43legacy: Fix firmware loading when driver is built
 into the kernel
Message-ID: <20130111133805.GA19224@kroah.com>
References: <20130109201458.392601412@linuxfoundation.org>
 <20130109201458.942583904@linuxfoundation.org>
 <1357876077.4514.7.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357876077.4514.7.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 03:47:57AM +0000, Ben Hutchings wrote:
> On Wed, 2013-01-09 at 12:34 -0800, Greg Kroah-Hartman wrote:
> > 3.7-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Larry Finger <Larry.Finger@lwfinger.net>
> > 
> > commit 576d28a7c73013717311cfcb514dbcae27c82eeb upstream.
> > 
> > Recent versions of udev cause synchronous firmware loading from the
> > probe routine to fail because the request to user space times out.
> [...]
> 
> This has since been fixed in udev, and the kernel can also load firmware
> directly.  So is this still worth doing?

I think so, as not all systems have, or can, update their version of
udev.

thanks,

greg k-h
