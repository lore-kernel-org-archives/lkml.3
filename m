Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaCMNGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:06:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaCMNGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:06:00 -0400
Message-ID: <1394715959.21617.19.camel@linux-fkkt.site>
Subject: Re: Check if usb device is suspended
From: Oliver Neukum <oneukum@suse.de>
To: Jagdish Gedia <jvgediya@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Mar 2014 14:05:59 +0100
In-Reply-To: <CAOAoqGt_Y_weA2FjA8x-NrZS7zj+=Zw-TH5Xv+QUQDJQixmdsw@mail.gmail.com>
References: <CAOAoqGt_Y_weA2FjA8x-NrZS7zj+=Zw-TH5Xv+QUQDJQixmdsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 17:13 +0530, Jagdish Gedia wrote:
> Hi,
> I want to check in my driver if usb device is suspended or not?
> currently i am doing it like
> 
> if(udev->state==USB_STATE_SUSPENDED)
> 
> Is this the proper way? Is this enough?

This question is near meaningless. Assuming that you
don't check for fun, but want to act on the state,
the meaningful question would be how you know that
a device is still suspended (or not) while you perform
the actions you base on that information.

	Regards
		Oliver


