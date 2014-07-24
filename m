Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270AbaGXHh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:37:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbaGXHhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:37:25 -0400
Date: Thu, 24 Jul 2014 00:37:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH v4] Lattice ECP3 FPGA: Correct endianness
Message-ID: <20140724073700.GA11963@kroah.com>
References: <CAL8zT=g5aO1aNbADQ9Usv6J952D5t8_NvmDozTjvtczq-BGbrw@mail.gmail.com>
 <20140723235850.GA1241@kroah.com>
 <CAL8zT=hQcxbrT_ti5Y6Jzk3WxEZ3fR00gE_+4ZLe+GY2HDs3dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL8zT=hQcxbrT_ti5Y6Jzk3WxEZ3fR00gE_+4ZLe+GY2HDs3dg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 08:53:30AM +0200, Jean-Michel Hautbois wrote:
> > Your email client ate all the tabs and spit out spaces and then
> > line-wrapped the patch, making it impossible to apply :(
> >
> > Can you fix it up and resend it in a format we can use?
> >
> > thanks,
> >
> > greg k-h
> 
> GMail GUI is a nightmare, I can't find an option to tell it to let me
> send whatever I want... :(
> I will use Thunderbird then !

Please see Documentation/email-clients.txt for help with this.
