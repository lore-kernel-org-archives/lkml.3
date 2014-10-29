Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbaJ2XYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:24:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbaJ2XYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:24:04 -0400
Date: Thu, 30 Oct 2014 00:24:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Jiri Kosina <jkosina@suse.cz>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de,
        tj@kernel.org, marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
In-Reply-To: <20141029231106.GB16548@kroah.com>
Message-ID: <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:

> > > kdbus is a kernel-level IPC implementation that aims for resemblance to
> > > the the protocol layer with the existing userspace D-Bus daemon while
> > > enabling some features that couldn't be implemented before in userspace.
> > 
> > I'd be interested in the features that can't be implemented in userspace 
> > (and therefore would justify existence of kdbus in the kernel). Could you 
> > please point me to such list / documentation?
> 
> Lennart has given whole talks about this in the past, here's a recent
> talk going into the details:
> 	https://www.youtube.com/watch?v=HPbQzm_iz_k

I think it's a reasonable expectation that kernel patch submissions should 
be reasonably self-contained though. We've always been very strict about 
pushing everybody to provide extensive cover letters, changelogs and 
explanations, so this shouldn't really be an exception, I think.

> > It seems to me that most of the highlight features from the cover letter 
> > can be "easily" (for certain definition of that word, of course) 
> > implemented in userspace (vmsplice(), sending fd through unix socket, user 
> > namespaces, UUID management, etc).
> 
> We have dbus in userspace today, but that requires extra copies of data,

But we can do zero-copy between processess for quite some time already, so 
what exactly is the issue here?

> and isn't easy, or even possible, to do some of the application-specific
> bus logic that kdbus provides.  

I unfortunately have absolutely no idea what should I imagine here.

> See the talk above for details, there are slides around somewhere with 
> just text that we can add to the cover letter if that will help out in 
> future spins of this patch series.

I think that would be very helpful. Thanks.

-- 
Jiri Kosina
SUSE Labs

