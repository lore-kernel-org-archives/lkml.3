Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab3GRWpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:45:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3GRWps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:45:48 -0400
Date: Thu, 18 Jul 2013 15:45:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        koen@dominion.thruhere.net
Subject: Re: [PATCH 01/15] MFD: ti_tscadc: disable TSC config registers in
 adc mode
Message-ID: <20130718224555.GA7116@kroah.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374186086-5015-2-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374186086-5015-2-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 11:21:12PM +0100, Zubair Lutfullah wrote:
> From: "Patil, Rachna" <rachna@ti.com>
> 
> AFE Pen Ctrl and TouchScreen transistors enabling is not
> required when only ADC mode is being used, so check for availability of
> TSC driver before accessing control register.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>

Did Rachna really sign off on this, and the other, patches?  Or did they
just author them and place them somewhere on the web?  You can't add
other people's signed-off-by lines, that's not allowed for obvious
reasons (read what Signed-off-by: means in the
Documentation/SubmittingPatches file if you are curious.)

thanks,

greg k-h
