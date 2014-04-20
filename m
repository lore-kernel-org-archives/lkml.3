Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaDTKEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 06:04:31 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:38283 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaDTKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 06:04:21 -0400
Date: Sun, 20 Apr 2014 12:04:19 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [git pull] drm fixes
Message-ID: <20140420100419.GA283@x4>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
 <20140419190305.GA267@x4>
 <CADnq5_M9COdOJhOu4_9yRpDoFt3bcc9HVqrvQqnYM3YuTLv15A@mail.gmail.com>
 <20140420062450.GA281@x4>
 <535384FC.1060708@vodafone.de>
 <20140420095612.GA268@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140420095612.GA268@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.04.20 at 11:56 +0200, Markus Trippelsdorf wrote:
> On 2014.04.20 at 10:27 +0200, Christian König wrote:
> > > I did and it doesn't fix the issue.
> > In this case please open up a new bugreport on 
> > https://bugs.freedesktop.org/enter_bug.cgi?product=DRI and select 
> > DRM/Radeon as component.
> > 
> > Additional to that please provide a dmesg output generated with 
> > drm.debug=0xE for both the good and the bad case.
> 
> Good vs. bad:

Sorry it is actually bad vs. good:

> -[drm:radeon_compute_pll_avivo] 146250 - 14439, pll dividers - fb: 2047.0 ref: 29, post 7
> +[drm:radeon_compute_pll_avivo] 146250 - 14955, pll dividers - fb: 1023.5 ref: 14, post 7

-- 
Markus
