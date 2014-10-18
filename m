Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaJRKmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 06:42:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaJRKmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 06:42:04 -0400
Date: Sat, 18 Oct 2014 12:40:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org,
        Steven Honeyman <stevenhoneyman@gmail.com>
Subject: Re: [PATCH] i8k: Add support for Dell Latitude E6440
Message-ID: <20141018104056.GA8607@kroah.com>
References: <1412932368-24082-1-git-send-email-pali.rohar@gmail.com>
 <54384817.6060102@roeck-us.net>
 <201410180023.39473@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201410180023.39473@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 12:23:39AM +0200, Pali Rohár wrote:
> On Friday 10 October 2014 22:56:55 Guenter Roeck wrote:
> > On 10/10/2014 02:12 AM, Pali Rohár wrote:
> > > Dell Latitude E6440 needs same settings as E6540.
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > 
> > Acked-by: Guenter Roeck <linux@roeck-us.net>
> > 
> 
> Greg, Arnd: PING
> 
> Can you apply also this patch for E6440? Support for E6540 is 
> already in linus tree: 06c88b0d7ad87540405aea7f91d98ef43be04c95

I can't apply anything to my trees until 3.18-rc1 is out, but will do
this after that happens.

thanks,

greg k-h
