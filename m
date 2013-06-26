Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3FZRWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:22:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab3FZRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:22:08 -0400
Date: Wed, 26 Jun 2013 10:22:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [07/26] USB: serial: ti_usb_3410_5052: new device id for Abbot
 strip port cable
Message-ID: <20130626172207.GA3244@kroah.com>
References: <lsq.1372214158.308371705@decadent.org.uk>
 <201306260821.r5Q8LM18003679@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306260821.r5Q8LM18003679@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:21:22AM +0200, Anders Hammarquist wrote:
> In a message of Wed, 26 Jun 2013 03:35:58 +0100, Ben Hutchings writes:
> >3.2.48-rc1 review patch.  If anyone has any objections, please let me know.
> >
> >------------------
> >
> >From: Anders Hammarquist <iko@iko.pp.se>
> >
> >commit 35a2fbc941accd0e9f1bfadd669311786118d874 upstream.
> >
> >Add product id for Abbott strip port cable for Precision meter which
> >uses the TI 3410 chip.
> 
> It needs to be paired with later patches that fix the statically sized
> usb_device_id array, so I don't think it should go in alone.

See my other response as to why I think this patch, as-is, is fine to go
in.

thanks,

greg k-h
