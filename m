Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaBLUV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:21:28 -0500
Received: from 1wt.eu ([62.212.114.60]:56978 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaBLUV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:21:27 -0500
Date: Wed, 12 Feb 2014 21:21:22 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/120] 3.13.3-stable review
Message-ID: <20140212202122.GA22611@1wt.eu>
References: <20140211184823.492407127@linuxfoundation.org> <20140212083223.GD13873@1wt.eu> <20140212162643.GA21336@kroah.com> <20140212162957.GG17206@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212162957.GG17206@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Feb 12, 2014 at 05:29:57PM +0100, Willy Tarreau wrote:
> > > I upgraded my netbook from 3.10.x to test it (asus 1025C). It seems
> > > to work, cpufreq, SATA, FB, Xorg (gma500), wifi (ath9k), LAN (atl1c),
> > > sound, suspend. I'm hearing the fan run all the time without the CPU
> > > spinning, but I suspect that it's the result of upgrading from 3.10
> > > to 3.13, I'll have to dig that later (I didn't find anything related
> > > to this in .3-rc1). I know this is very limited for a test, but it's
> > > all I can provide for now.
> > 
> > Can you verify if 3.13.0 also has this problem for you or not?
> 
> I will, I just didn't have enough time this morning to do a second build.

OK false alarm. It's an artefact of the kernel upgrade operations
(depmod etc). Whatever the version (3.10.18, 3.13, 3.13.3-rc1), the
fan runs fast at boot and slowly fades out. I usually do not hear
this since I wake it up from suspend. The CPU heats during boot,
and I suspect there's some dust in the fan making it spin longer
than it used to.

So please disregard my comment, 3.13.3-rc1 apparently works correctly
here!

Cheers,
Willy

