Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaB0Ea4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:30:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaB0Eaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:30:55 -0500
Date: Wed, 26 Feb 2014 20:32:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
Message-ID: <20140227043256.GB3644@kroah.com>
References: <530E6F76.1070605@zytor.com>
 <20140226232859.GA9213@kroah.com>
 <530E82B2.3040305@zytor.com>
 <20140227013424.GA9991@kroah.com>
 <20140227031508.GA8950@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227031508.GA8950@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:15:08PM -0500, Dave Jones wrote:
> On Wed, Feb 26, 2014 at 05:34:24PM -0800, Greg KH wrote:
> 
>  > Yes, for some areas of the kernel it will take some work, but for
>  > others, sparse works really well.  As an example, building all of
>  > drivers/usb/* with sparse only brings up 2 issues, both of which should
>  > probably be fixed (or annotated properly in the case of the locking
>  > warning.)
> 
> Hm. I see 102 in drivers/usb. Mostly in gadget. 
> http://paste.fedoraproject.org/80787/39347077/raw/

Ick, gadget, I don't build that for my systems as I don't have that
hardware, sorry, I forgot to take that into consideration here.

Hey, at least I know what I'm going to be doing tomorrow :)

greg k-h
