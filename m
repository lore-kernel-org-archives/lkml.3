Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaKZAzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:55:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaKZAzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:55:43 -0500
Date: Tue, 25 Nov 2014 16:55:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rafael.j.wysocki@intel.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
Message-ID: <20141126005542.GA14758@kroah.com>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
 <20141125235108.GB3138@kroah.com>
 <54751A95.60805@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54751A95.60805@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 01:11:01AM +0100, Richard Weinberger wrote:
> Am 26.11.2014 um 00:51 schrieb Greg KH:
> > On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
> >> systemd has a hard dependency on CONFIG_FHANDLE.
> > 
> > It's been this way for a very long time, why is this suddenly an issue?
> 
> Because nobody cared to create patch and just called systemd names? ;-)

systemd documents what is needed in order for it to boot properly quite
well, I don't see why this needs to be here.

> > Do these files even make any sense anymore?  Who uses them?  The distros
> > sure do not...
> 
> Maybe I'm oldschool but I expect a defconfig kernel to be able to boot a
> recent distro.

You are :)
How does the defconfig know your hardware in order to be able to find
the root disk properly?  Video device?  USB keyboard?  and so on...

I thought we were getting rid of the defconfig files entirely one of
these days, didn't some arches already do this?

greg k-h
