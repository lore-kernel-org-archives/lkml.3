Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3HEHk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:40:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57690 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3HEHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:40:27 -0400
Date: Mon, 5 Aug 2013 09:40:33 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Jones <davej@redhat.com>, David Airlie <airlied@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.10rc6] /proc/dri/0/vma broken on nouveau.
Message-ID: <20130805074033.GX22035@phenom.ffwll.local>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Airlie <airlied@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
	dri-devel@lists.freedesktop.org
References: <20130618013602.GC2200@redhat.com>
 <1257782958.19234314.1371520167209.JavaMail.root@redhat.com>
 <20130730005335.GA6836@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730005335.GA6836@redhat.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 08:53:35PM -0400, Dave Jones wrote:
> On Mon, Jun 17, 2013 at 09:49:27PM -0400, David Airlie wrote:
>  > 
>  > > Reading /proc/dri/0/vma causes bad things to happen on a box with nouveau
>  > > loaded.
>  > > (Note, no X running on that box)
>  > > 
>  > > Trace below shows trinity, but I can reproduce it with just cat
>  > > /proc/dri/0/vma
>  > 
>  > How about this, lets just rip it all out.
> 
> No-one objected, and this is still around in 3.11-rc3 in the same
> easily oopsable state.. I vote we kill it with fire.

Can we make it burn brighter while at it?

http://cgit.freedesktop.org/~danvet/drm/commit/?h=for-dvdhrm&id=151591c2828e18fde1eb8447874704f3422168b0

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
