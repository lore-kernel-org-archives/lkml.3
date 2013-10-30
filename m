Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3J3R3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:29:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3J3R3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:29:06 -0400
Date: Wed, 30 Oct 2013 10:29:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: USB, TTY, char/misc, and Staging trees now closed for 3.13
Message-ID: <20131030172904.GA11800@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Given that 3.12 will be out in a few days, it's time to close my trees
for new patches until 3.13-rc1 is out.

The merge window for 3.13-rc1 is going to be a bit longer than normal as
Linus has pointed out, due to travel and conferences.  I'll also be
traveling for 2 weeks, so my response time to patches is going to be
_hugely_ delayed.

So much delayed, that I would _really_ appreciate people not sending
patches until 3.13-rc1 is out, just so that I can not have a ton of
pending patches to dig through when that happens.  If patches are sent
before 3.13-rc1 is out, I will queue them up, but note that it will be
delayed.

Due to travel, conferences, and other stuff I want to work on (i.e.
stable releases and xen kexec work), my response time to email is going
to be really slow for a few weeks.

thanks,

greg k-h
