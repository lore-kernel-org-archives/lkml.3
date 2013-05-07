Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab3EGCrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:47:43 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61153 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869Ab3EGCrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:47:42 -0400
Date: Mon, 6 May 2013 19:47:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Michael D. Setzer II" <msetzerii@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Firmware Support
Message-ID: <20130507024750.GA26639@kroah.com>
References: <51885C8A.28146.10AA3F@msetzerii.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51885C8A.28146.10AA3F@msetzerii.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 11:44:42AM +1000, Michael D. Setzer II wrote:
> Looking for method to best support users firmware needs within 
> the kernel. 
> 
> Have a disk-image project that users kernel.org kernels, and have 
> had users that require firmware that is not included in the 
> kernel.org source. I've been able to find it in linux-firmware.git and 
> then manually adding it to the kernel.org firmware directory and 
> then modifying the Makefile.

Use the linux-firmware package, all of the distros package it up for you
automatically, and install it in the correct place, so it should "just
work".

What is failing for you when you use the firmware package?

thanks,

greg k-h
