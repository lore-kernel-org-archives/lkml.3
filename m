Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbaJ2Xft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:35:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbaJ2Xfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:35:47 -0400
Date: Wed, 29 Oct 2014 16:34:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>, desrt@desrt.ca,
        hadess@hadess.net, dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141029233438.GA16520@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
 <20141029231106.GB16548@kroah.com>
 <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz>
 <alpine.LRH.2.00.1410300024530.11562@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1410300024530.11562@twin.jikos.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:26:33AM +0100, Jiri Kosina wrote:
> On Thu, 30 Oct 2014, Jiri Kosina wrote:
> 
> > > > It seems to me that most of the highlight features from the cover letter 
> > > > can be "easily" (for certain definition of that word, of course) 
> > > > implemented in userspace (vmsplice(), sending fd through unix socket, user 
> > > > namespaces, UUID management, etc).
> > > 
> > > We have dbus in userspace today, but that requires extra copies of data,
> > 
> > But we can do zero-copy between processess for quite some time already, so 
> > what exactly is the issue here?
> > 
> > > and isn't easy, or even possible, to do some of the application-specific
> > > bus logic that kdbus provides.  
> > 
> > I unfortunately have absolutely no idea what should I imagine here.
> 
> Also, I think I have heard that binder is going out of staging now, right?

Yes, but that needs documentation, which I'm working on at the moment :)

> I admittedly have very limited understanding of both binder and kdbus, but 
> I guess that is the case for many folks. My understanding is that they are 
> providing very similar functionality, so explanation why we need *both* in 
> the kernel would be very interesting as well.

They do very different things, see this writeup I did a while ago about
the differences between them:
	http://kroah.com/log/blog/2014/01/15/kdbus-details/

thanks,

greg k-h
