Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbaJ2X0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:26:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095AbaJ2X0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:26:35 -0400
Date: Thu, 30 Oct 2014 00:26:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>, desrt@desrt.ca,
        hadess@hadess.net, dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
In-Reply-To: <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz>
Message-ID: <alpine.LRH.2.00.1410300024530.11562@twin.jikos.cz>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com> <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Jiri Kosina wrote:

> > > It seems to me that most of the highlight features from the cover letter 
> > > can be "easily" (for certain definition of that word, of course) 
> > > implemented in userspace (vmsplice(), sending fd through unix socket, user 
> > > namespaces, UUID management, etc).
> > 
> > We have dbus in userspace today, but that requires extra copies of data,
> 
> But we can do zero-copy between processess for quite some time already, so 
> what exactly is the issue here?
> 
> > and isn't easy, or even possible, to do some of the application-specific
> > bus logic that kdbus provides.  
> 
> I unfortunately have absolutely no idea what should I imagine here.

Also, I think I have heard that binder is going out of staging now, right?

I admittedly have very limited understanding of both binder and kdbus, but 
I guess that is the case for many folks. My understanding is that they are 
providing very similar functionality, so explanation why we need *both* in 
the kernel would be very interesting as well.

-- 
Jiri Kosina
SUSE Labs

