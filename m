Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaFKOaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:30:20 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57611 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaFKOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:30:18 -0400
Date: Wed, 11 Jun 2014 15:30:12 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Mismatch in gmch_pfit.lvds_border_bits on EeePC 900
Message-ID: <20140611143011.GA13391@sucs.org>
References: <20140608213015.GA30713@sucs.org>
 <20140610062655.GA5821@phenom.ffwll.local>
 <20140611054640.GA31892@sucs.org>
 <20140611060339.GA6261@sucs.org>
 <20140611093229.GD5821@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611093229.GD5821@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 11:32:29AM +0200, Daniel Vetter wrote:
> On Wed, Jun 11, 2014 at 07:03:39AM +0100, Sitsofe Wheeler wrote:
> > 
> > On Wed, Jun 11, 2014 at 06:46:40AM +0100, Sitsofe Wheeler wrote:
> > > On Tue, Jun 10, 2014 at 08:26:55AM +0200, Daniel Vetter wrote:
> > > > On Sun, Jun 08, 2014 at 10:30:15PM +0100, Sitsofe Wheeler wrote:
> > > > > With a tree that is close to 3.15 final I'm regularly seeing the
> > > > > following on my EeePC 900 when starting ioquake3:
> > > > > 
> > > > > [drm:intel_pipe_config_compare] *ERROR* mismatch in gmch_pfit.lvds_border_bits (expected 32768, found 0)
> > > > 
> > > > Hm, I've thought we've fixed that by now. Alas, no :(
> > > > 
> > > > Can you please add drm.debug=0xe to your kernel cmdline, reproduce the
> > > > issue and attach the entire dmesg? Please make sure it contains everything
> > > > since boot-up so that we can reconstruct the state properly (might need to
> > > > grab it from logfiles if dmesg is cut off).
> > > 
> > > Please find kern.log.gz attached.
> 
> Not in the resend and I didn't seem to receive your original mail somehow
> at all. Can you please resend.

Downloadable from http://sucs.org/~sits/test/eeepc-900/dmesg-20140611 .

By the way, Mutt seems to be becoming upset when I group reply to your
mails. I think it's because your address is in both the To: and the Cc:
fields....

> > > > Also, do you have any ideas when you reproduce this? Anything that changes
> > > > the lvds output could be relevant ...
> > > 
> > > Doing
> > > xrandr -s 800x600
> > > xrandr -s 0
> > > 
> > > was enough to provoke the messages in the attached log.
> 
> Ok, makes sense. Smells a bit like leftover pfit state. Can you please
> also try latest drm-intel-nightly?

The previous log is from drm-intel-nightly but there seem to be more
warnings in it rather than less...

-- 
Sitsofe | http://sucs.org/~sits/
