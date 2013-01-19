Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3ASEw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 23:52:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3ASEwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 23:52:55 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=oS6VeJ3zRZwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ylgaL1uFd_sA:10 a=mglTsNybAAAA:20 a=WeLpJKWFmSSlEFhsx2EA:9 a=PUjeQqilurYA:10 a=l38a4HPC-fwA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358571172.23981.5.camel@gandalf.local.home>
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@linuxfoundation.org>,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 18 Jan 2013 23:52:52 -0500
In-Reply-To: <20130116164238.625db60c@bob.linux.org.uk>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
	 <20130116064735.GA7743@kroah.com> <50F6AD15.708@suse.cz>
	 <1358351064.4068.43.camel@gandalf.local.home> <50F6CE7E.4090807@suse.cz>
	 <20130116164238.625db60c@bob.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 16:42 +0000, Alan Cox wrote:
> On Wed, 16 Jan 2013 16:59:58 +0100

> > OMG. It contains a true copy of serial_core!
> 
> And it seems to just be another 165x0 driver anyway In fact it looks
> like the right thing to do is to take it out and shoot it. We've got a
> 16x50 driver already.
> 
> There are a few bits of gunk in there to set custom board registers and
> to figure out the configuration. See drivers/tty/serial/8250/8250_pci.c
> and it ought to be possible to just plug it in there. The 422 stuff
> might need a bit more tweaking.

I've totally failed trying to get it working with 8250. I'm going to
start from scratch and take bits and pieces from other drivers and put
together something (hopefully) a bit more sane.

It actually has a lot of duplicate code from omap-serial.c, or whatever
omap-serial copied from. I'm using that as a guide as well.

I'll post something in a few weeks (I'm basically doing this outside of
my regular choirs). It will still be crap, as I'm really a noob with the
serial tty code.

I've written serial drivers in the past, but just to get things to do
basic communication. Nothing with interacting with the tty layer. That's
new for me, and as a noob, I'm sure I'll produce something that will
surely make all of you go...

  http://bit.ly/10hq0Kh

-- Steve


