Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaKGQNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:13:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaKGQNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:13:00 -0500
Date: Fri, 7 Nov 2014 08:12:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: jslaby@suse.cz, cascardo@linux.vnet.ibm.com, markh@compro.net,
        devel@driverdev.osuosl.org, lidza.louina@gmail.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 3/4] staging: dgnc: Remove driver in favor of
 serial/jsm driver
Message-ID: <20141107161258.GA12566@kroah.com>
References: <20141106191808.GA32427@kroah.com>
 <1415315135-29716-1-git-send-email-bergo.torino@gmail.com>
 <1415315135-29716-2-git-send-email-bergo.torino@gmail.com>
 <1415315135-29716-3-git-send-email-bergo.torino@gmail.com>
 <1415315135-29716-4-git-send-email-bergo.torino@gmail.com>
 <20141106232012.GA8585@kroah.com>
 <20141106233623.GJ29761@t400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106233623.GJ29761@t400>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 12:36:23AM +0100, Konrad Zapalowicz wrote:
> On 11/06, Greg KH wrote:
> > On Fri, Nov 07, 2014 at 12:05:34AM +0100, Konrad Zapalowicz wrote:
> > > This commit removes the staging/dgnc driver in favor of the serial/jsm
> > > driver.
> > > 
> > > This is because the serial/jsm driver now supports all of the hardware
> > > that has been supported by the staging/dgnc plus it offers better
> > > overall quality.
> > > 
> > > Given above the staging/dgnc is obsolete now.
> > > 
> > > Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
> > 
> > I've applied the other patches in this series, but am going to skip this
> > one at the moment until I get some "it works for me" verification from
> > someone who has this hardware.
> 
> I will have some patches following-up this series, mostly fixing some
> minor stuff that I found going through the current jsm code plus the
> stuff that can now be shared between neo and cls code. So should I send
> it and it will end up in the tty testing tree or wait till my patches
> will make it to the next/mainline.

Please send them whenever you have them done and you feel they are
correct.

> In case you want the patches should I mark them somehow so that you know
> it is something that should go to the tty testing tree?

If you just send them saying it is against my tty-testing (or tty-next,
as your patches are now merged into that), it's fine.

thanks,

greg k-h
