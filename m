Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbbANUnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:43:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbANUnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:43:31 -0500
Date: Wed, 14 Jan 2015 12:43:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Tonello <eu@felipetonello.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] char: Added support for u-blox 6 i2c gps driver
Message-ID: <20150114204330.GB31119@kroah.com>
References: <1421198202-4042-1-git-send-email-eu@felipetonello.com>
 <20150114154816.58b0f9c7@lxorguk.ukuu.org.uk>
 <CAGrhNMysmq==Y0naNki0z5usmMwUErj-FOTy=8KH0V=R7=VFwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGrhNMysmq==Y0naNki0z5usmMwUErj-FOTy=8KH0V=R7=VFwA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:39:04AM -0800, Felipe Tonello wrote:
> The thing is that: I wrote this driver to work with only one gps
> module, because that's my configuration here. I cannot really test
> multiple i2c gps at the same time. If you guys really want a driver
> that works for multiple gps drivers, I cannot test it.
> 
> So my question is, can I leave the driver working for one gps only and
> then improve what needs to be improved?

No, write it to handle any number of devices, the logic is the same for
one, or one thousand, there should not be any issues in the driver that
make this any different.

thanks,

greg k-h
