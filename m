Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3BKOmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:42:43 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:52509 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3BKOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:42:42 -0500
Message-ID: <1360593750.25941.13.camel@thor.lan>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476  (tty is NULL)
From: Peter Hurley <peter@hurleysoftware.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 11 Feb 2013 09:42:30 -0500
In-Reply-To: <20130211024412.GA7623@concordia>
References: <20130102153744.GC25940@redhat.com>
	 <20130118205358.GA6854@redhat.com> <20130118210728.GA16742@kroah.com>
	 <50FB0957.2000400@suse.cz> <1359570837.3325.30.camel@thor.lan>
	 <20130211024412.GA7623@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, 2013-02-11 at 13:44 +1100, Michael Ellerman wrote:
> On Wed, Jan 30, 2013 at 01:33:57PM -0500, Peter Hurley wrote:
> > On Sat, 2013-01-19 at 22:00 +0100, Jiri Slaby wrote:
> > > On 01/18/2013 10:07 PM, Greg Kroah-Hartman wrote:
> > > > Jiri, was there anything on the mailing list that I missed that should
> > > > have resolved this issue?  I thought it was being worked on, but I can't
> > > > seem to find any resolution at the moment.
> > > 
> > > Somebody had a patchset and promised to repost IIRC. I forgot his name
> > > though.
> > > 
> > > /me back from digging in the mail history.
> > > 
> > > Peter Hurley is the name.
> > > 
> > > Peter, what happened with your patches in the end, please?
> > 
> > The tty subsystem is very resilient to fixing :)
> > 
> > The thing I'm working on right now -- which hopefully is the last issue
> > with the line discipline logic -- occurs with parallel __tty_hangup()
> > and tty_release().
> > 
> > At the moment, I'm trying to narrow the conditions when this happens.
> 
> If it helps I seem to be able to reproduce this in just a few seconds by
                                   ^^^^^^^^^^^^^^
                 you get this WARNING from a parallel __tty_hangup?

Or do you mean simply that you get this WARNING?

> running trinity and hitting Ctrl-C to quit the watchdog.

Can you reproduce after using the following patch series?
[PATCH v3 00/23] ldisc fixes

Regards,
Peter Hurley

