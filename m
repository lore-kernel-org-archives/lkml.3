Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3GSXNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:13:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3GSXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:13:48 -0400
Date: Fri, 19 Jul 2013 16:13:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        koen@dominion.thruhere.net
Subject: Re: [PATCH 01/15] MFD: ti_tscadc: disable TSC config registers in
 adc mode
Message-ID: <20130719231352.GB1701@kroah.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374186086-5015-2-git-send-email-zubair.lutfullah@gmail.com>
 <20130718224555.GA7116@kroah.com>
 <20130719204715.GA8704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719204715.GA8704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 09:47:16PM +0100, Zubair Lutfullah : wrote:
> On Thu, Jul 18, 2013 at 03:45:55PM -0700, Greg KH wrote:
> 
> > Did Rachna really sign off on this, and the other, patches?  Or did they
> Authored and signed off on it in their TI tree. based on 3.2.

Ok, as long as they did that, it's fine to have those lines in the
patch.  As you didn't have them in the previous version, I had to ask.

thanks,

greg k-h
