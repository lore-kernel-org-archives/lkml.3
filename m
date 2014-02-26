Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaBZX2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:28:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaBZX2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:28:19 -0500
Date: Wed, 26 Feb 2014 15:29:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
Message-ID: <20140226232954.GA17791@kroah.com>
References: <530E6F76.1070605@zytor.com>
 <20140226232859.GA9213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226232859.GA9213@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 03:28:59PM -0800, Greg KH wrote:
> On Wed, Feb 26, 2014 at 02:49:26PM -0800, H. Peter Anvin wrote:
> > The number of sparse errors in the current kernel is staggering, and it
> > makes sparse a lot less valuable of a tool that it otherwise could be.
> > On a build of x86-64 allyesconfig I'm getting 20,676 sparse messages.
> > Out of those, 12,358 come from linux/err.h.  Given that the latter
> > basically spams *everything*, I can only conclude that almost noone uses
> > sparse unless they have a filter script.
> 
> What errors are you seeing from err.h?  I don't see those when building
> different subdirectories with sparse (which is how I normally use it.)
> 
> And what version of sparse are you running:
> 	$ sparse --version
> 	v0.4.5-rc1-407-g345e8943fc36

Ah, 0.5.0 is now out, maybe you should update to that version?

thanks,

greg k-h
