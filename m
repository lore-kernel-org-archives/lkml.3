Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaGHNoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:44:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64471 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaGHNoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:44:19 -0400
Date: Tue, 8 Jul 2014 15:44:27 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "Clark, Rob" <robdclark@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 0/9] Updated fence patch series
Message-ID: <20140708134427.GG17271@phenom.ffwll.local>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	"open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"Clark, Rob" <robdclark@gmail.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Colin Cross <ccross@google.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20140701103432.12718.82795.stgit@patser>
 <20140702053758.GA7578@kroah.com>
 <CAKMK7uHZQjQ2m7KE22kTRVs-NtGguHREk24pSJiLbN7EoQLZ=g@mail.gmail.com>
 <20140707173052.GA8693@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707173052.GA8693@kroah.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 10:30:52AM -0700, Greg KH wrote:
> On Mon, Jul 07, 2014 at 03:23:17PM +0200, Daniel Vetter wrote:
> > On Wed, Jul 2, 2014 at 7:37 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >> Android can expose fences to userspace. It's possible to make the new fence
> > >> mechanism expose the same fences to userspace by changing sync_fence_create
> > >> to take a struct fence instead of a struct sync_pt. No other change is needed,
> > >> because only the fence parts of struct sync_pt are used. But because the
> > >> userspace fences are a separate problem and I haven't really looked at it yet
> > >> I feel it should stay in staging, for now.
> > >
> > > Ok, that's reasonable.
> > >
> > > At first glance, this all looks "sane" to me, any objection from anyone
> > > if I merge this through my driver-core tree for 3.17?
> > 
> > Ack from my side fwiw.
> 
> Thanks, I'll queue it up later today.

btw should we add you as a (co)maintainer for driver/core/dma-buf since
you seem to want to keep a closer tab on what the insane gfx folks are up
to in there?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
