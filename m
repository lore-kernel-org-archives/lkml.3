Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3FROqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:46:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab3FROqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:46:37 -0400
Date: Tue, 18 Jun 2013 07:47:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Pavel Machek <pavel@denx.de>, dzu@denx.de, hjk@hansjkoch.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow binding drivers/uio/uio_pdrv_genirq.c to devices
 using command line option
Message-ID: <20130618144715.GB26587@kroah.com>
References: <20130412184335.GA5510@amd.pavel.ucw.cz>
 <20130617134741.GA15547@amd.pavel.ucw.cz>
 <20130617173738.GA14921@kroah.com>
 <CAK9yfHxMpzPuDP4D8EztaUxseuZCX7VEHFB7dBWtntDDjZJD6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK9yfHxMpzPuDP4D8EztaUxseuZCX7VEHFB7dBWtntDDjZJD6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:32:33AM +0530, Sachin Kamat wrote:
> Hi Greg,
> 
> On 17 June 2013 23:07, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Jun 17, 2013 at 03:47:41PM +0200, Pavel Machek wrote:
> >> Hi!
> >>
> >> > This adds ability to bind uio driver to given open firmware device
> >> > using command line option. Thus, userspace driver can be developed and
> >> > used without modifying the kernel.
> >> >
> >> > Signed-off-by: Pavel Machek <pavel@denx.de>
> >>
> >> Ping? Greg, could you apply this patch? Or is there someone else I
> >> should ask to apply it?
> >
> > Ugh, Hans seems to have dropped off of the net for a long time now, so I
> > guess I'll start queueing up UIO patches again.  Care to resend this?
> >
> 
> Even I have a couple of outstanding UIO patches [1-2]. Shall I resend
> them as well?
> 
> [1] https://lkml.org/lkml/2013/3/14/154
> [2] https://patchwork.kernel.org/patch/2268921/

Yes, please do.

thanks,

greg k-h
