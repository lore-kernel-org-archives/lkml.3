Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3FZRVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:21:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3FZRVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:21:23 -0400
Date: Wed, 26 Jun 2013 10:21:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 17/17] USB: serial: ti_usb_3410_5052: new device id for Abbot
 strip port cable
Message-ID: <20130626172122.GB14661@kroah.com>
References: <20130625183915.443950649@linuxfoundation.org>
 <20130625183917.373592561@linuxfoundation.org>
 <201306252139.r5PLdQpP017104@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306252139.r5PLdQpP017104@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:39:26PM +0200, Anders Hammarquist wrote:
> In a message of Tue, 25 Jun 2013 11:39:32 -0700, Greg Kroah-Hartman writes:
> >3.0-stable review patch.  If anyone has any objections, please let me know.
> >
> >From: Anders Hammarquist <iko@iko.pp.se>
> >
> >commit 35a2fbc941accd0e9f1bfadd669311786118d874 upstream.
> >
> >Add product id for Abbott strip port cable for Precision meter which
> >uses the TI 3410 chip.
> 
> Given the statically sized arrays, I think this patch should not go in
> alone. It needs to go together with the later patches I sent you that
> fix the array sizing.
> 
> (this applies to all trees)

Yes, but, thanks to the fact that you are only adding one more device
id, I don't think we are overflowing anything with this patch alone,
right?  The only "bad" thing that could happen here is if a user
specifies a device/vendor id on the module command line, is it would
replace the device id you added, so all should be fine.

Or am I reading the code wrong?

thanks,

greg k-h
