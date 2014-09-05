Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaIETMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:12:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIETMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:12:03 -0400
Date: Fri, 5 Sep 2014 12:12:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Honeyman <stevenhoneyman@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Add support for Dell Latitude E6540
Message-ID: <20140905191203.GB24879@kroah.com>
References: <1409936622-5241-1-git-send-email-stevenhoneyman@gmail.com>
 <20140905185926.GA26476@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905185926.GA26476@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:59:26AM -0700, Guenter Roeck wrote:
> On Fri, Sep 05, 2014 at 06:03:42PM +0100, Steven Honeyman wrote:
> > Add support for the Dell Latitude E6540 which needs a different fan speed multiplier.
> > 
> > Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>
> 
> Looks good.
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> 
> Greg / Arnd, can you pick this up directly, or should I send
> a pull request ?

I can take it, thanks.

greg k-h
