Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbaJ2XNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:13:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbaJ2XNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:13:40 -0400
Date: Wed, 29 Oct 2014 16:12:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141029231231.GA19344@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
 <20141029231106.GB16548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029231106.GB16548@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:11:06PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Oct 30, 2014 at 12:00:16AM +0100, Jiri Kosina wrote:
> > On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:
> > 
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
> 
> > It seems to me that most of the highlight features from the cover letter 
> > can be "easily" (for certain definition of that word, of course) 
> > implemented in userspace (vmsplice(), sending fd through unix socket, user 
> > namespaces, UUID management, etc).
> 
> We have dbus in userspace today, but that requires extra copies of data,
> and isn't easy, or even possible, to do some of the application-specific
> bus logic that kdbus provides.  See the talk above for details, there
> are slides around somewhere with just text that we can add to the cover
> letter if that will help out in future spins of this patch series.

Here's an article describing it as well:
	https://lwn.net/Articles/580194/
