Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaGGR0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:26:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGGR03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:26:29 -0400
Date: Mon, 7 Jul 2014 10:30:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
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
Message-ID: <20140707173052.GA8693@kroah.com>
References: <20140701103432.12718.82795.stgit@patser>
 <20140702053758.GA7578@kroah.com>
 <CAKMK7uHZQjQ2m7KE22kTRVs-NtGguHREk24pSJiLbN7EoQLZ=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHZQjQ2m7KE22kTRVs-NtGguHREk24pSJiLbN7EoQLZ=g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 03:23:17PM +0200, Daniel Vetter wrote:
> On Wed, Jul 2, 2014 at 7:37 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> Android can expose fences to userspace. It's possible to make the new fence
> >> mechanism expose the same fences to userspace by changing sync_fence_create
> >> to take a struct fence instead of a struct sync_pt. No other change is needed,
> >> because only the fence parts of struct sync_pt are used. But because the
> >> userspace fences are a separate problem and I haven't really looked at it yet
> >> I feel it should stay in staging, for now.
> >
> > Ok, that's reasonable.
> >
> > At first glance, this all looks "sane" to me, any objection from anyone
> > if I merge this through my driver-core tree for 3.17?
> 
> Ack from my side fwiw.

Thanks, I'll queue it up later today.

greg k-h
